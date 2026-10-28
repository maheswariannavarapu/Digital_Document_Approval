import os

from datetime import datetime

from functools import wraps

from werkzeug.utils import secure_filename

from werkzeug.security import generate_password_hash, check_password_hash

from flask import (

    Flask, render_template, request, redirect, url_for, flash,

    session, send_from_directory

)

from database import get_db_connection, log_audit



app = Flask(__name__)

app.config['SECRET_KEY'] = 'docflow_super_secret_key_2026'

app.config['UPLOAD_FOLDER'] = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'uploads')

app.config['MAX_CONTENT_LENGTH'] = 32 * 1024 * 1024  # 32 MB max

ALLOWED_EXTENSIONS = {'pdf', 'docx', 'doc', 'png', 'jpg', 'jpeg'}



os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)



def allowed_file(filename):

    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS



@app.context_processor

def inject_user():

    return dict(current_user=session.get('user'))



def login_required_custom(f):

    @wraps(f)

    def decorated_function(*args, **kwargs):

        if 'user' not in session:

            flash('Please log in to access this page.', 'warning')

            return redirect(url_for('user_login'))

        return f(*args, **kwargs)

    return decorated_function



# --- Routes ---



@app.route('/')

def home():

    """Landing Page (Hero Screen)"""

    return render_template('home.html')



@app.route('/login', methods=['GET', 'POST'])

def user_login():

    """User Authentication Screen - Resets session on GET so login form always displays"""

    if request.method == 'POST':

        identifier = request.form.get('username')

        password = request.form.get('password')



        conn = get_db_connection()

        with conn.cursor() as cur:

            cur.execute("SELECT * FROM users WHERE username = %s OR email = %s", (identifier, identifier))

            user = cur.fetchone()

        conn.close()



        if user and check_password_hash(user['password'], password):

            session['user'] = {

                'id': user['id'],

                'username': user['username'],

                'full_name': user['full_name'],

                'email': user['email'],

                'role': user['role'],

                'designation': user.get('designation', '')

            }

            log_audit(None, user['id'], 'User Login', f"{user['username']} logged into platform.")

            flash(f"Welcome back, {user['full_name']}!", 'success')

            if user['role'] == 'admin':

                return redirect(url_for('admin_dashboard'))

            return redirect(url_for('user_dashboard'))

        else:

            flash('Invalid username or password.', 'danger')



    session.clear()

    return render_template('user_login.html')



@app.route('/admin/login', methods=['GET', 'POST'])

def admin_login():

    """Admin specific authentication screen"""

    if request.method == 'POST':

        identifier = request.form.get('username')

        password = request.form.get('password')



        conn = get_db_connection()

        with conn.cursor() as cur:

            cur.execute("SELECT * FROM users WHERE (username = %s OR email = %s) AND role = 'admin'", (identifier, identifier))

            admin = cur.fetchone()

        conn.close()



        if admin and check_password_hash(admin['password'], password):

            session['user'] = {

                'id': admin['id'],

                'username': admin['username'],

                'full_name': admin['full_name'],

                'email': admin['email'],

                'role': admin['role'],

                'designation': admin.get('designation', '')

            }

            log_audit(None, admin['id'], 'Admin Login', 'Admin session authenticated.')

            return redirect(url_for('admin_dashboard'))

        else:

            flash('Invalid Admin credentials.', 'danger')



    session.clear()

    return render_template('admin_login.html')



@app.route('/register', methods=['GET', 'POST'])

def user_register():

    if request.method == 'POST':

        username = request.form['username']

        email = request.form['email']

        full_name = request.form['full_name']

        role = request.form.get('role', 'user')

        raw_password = request.form['password']

        hashed_password = generate_password_hash(raw_password)



        conn = get_db_connection()

        try:

            with conn.cursor() as cur:

                cur.execute("""

                    INSERT INTO users (username, email, password, full_name, role)

                    VALUES (%s, %s, %s, %s, %s)

                """, (username, email, hashed_password, full_name, role))

            conn.close()

            flash('Account created successfully! Please login.', 'success')

            return redirect(url_for('user_login'))

        except Exception as e:

            conn.close()

            flash(f'Registration error: {e}', 'danger')



    return render_template('user_register.html')



@app.route('/logout')

def logout():

    user = session.get('user')

    if user:

        log_audit(None, user['id'], 'User Logout', f"{user['username']} logged out.")

    session.clear()

    flash('You have been safely logged out.', 'info')

    return redirect(url_for('home'))



@app.route('/download/<path:filename>')

@login_required_custom

def download_file(filename):

    """File download handler"""

    return send_from_directory(app.config['UPLOAD_FOLDER'], filename, as_attachment=True)



@app.route('/dashboard')

@login_required_custom

def user_dashboard():

    """Smart Dashboard Routing: Separates User, Reviewer, and Manager views"""

    user = session['user']

    conn = get_db_connection()

    with conn.cursor() as cur:

        # 1. REVIEWER PORTAL

        if user['role'] == 'reviewer':

            cur.execute("""

                SELECT d.*, dt.name as category_name, u.full_name as author_name,

                       ra.reviewer_id, ra.manager_id, ra.deadline

                FROM documents d

                LEFT JOIN document_types dt ON d.type_id = dt.id

                LEFT JOIN users u ON d.uploaded_by = u.id

                LEFT JOIN review_assignments ra ON d.id = ra.document_id

                WHERE (ra.reviewer_id = %s OR ra.reviewer_id IS NULL)

                  AND d.status IN ('submitted', 'in_review')

                ORDER BY d.id DESC

            """, (user['id'],))

            documents = cur.fetchall()



            pending_count = len(documents)

            cur.execute("""

                SELECT COUNT(*) as count FROM documents d

                JOIN approvals a ON d.id = a.document_id

                WHERE a.user_id = %s

            """, (user['id'],))

            completed_count = cur.fetchone()['count']



            conn.close()

            return render_template(

                'reviewer_dashboard.html',

                documents=documents,

                pending_count=pending_count,

                completed_count=completed_count

            )



        # 2. MANAGER PORTAL

        elif user['role'] == 'manager':

            cur.execute("""

                SELECT d.*, dt.name as category_name, u.full_name as author_name,

                       ra.reviewer_id, ra.manager_id, ra.deadline

                FROM documents d

                LEFT JOIN document_types dt ON d.type_id = dt.id

                LEFT JOIN users u ON d.uploaded_by = u.id

                LEFT JOIN review_assignments ra ON d.id = ra.document_id

                WHERE d.status = 'manager_review'

                   OR (ra.manager_id = %s AND d.status NOT IN ('approved', 'rejected'))

                ORDER BY d.id DESC

            """, (user['id'],))

            documents = cur.fetchall()



            pending_count = len(documents)

            cur.execute("""

                SELECT COUNT(*) as count FROM documents d

                JOIN approvals a ON d.id = a.document_id

                WHERE a.user_id = %s

            """, (user['id'],))

            completed_count = cur.fetchone()['count']



            conn.close()

            return render_template(

                'reviewer_dashboard.html',

                documents=documents,

                pending_count=pending_count,

                completed_count=completed_count

            )



        # 3. REGULAR USER PORTAL

        cur.execute("""

            SELECT d.*, dt.name as category_name, u.full_name as author_name,

                   ra.reviewer_id, ra.manager_id, ra.deadline,

                   rev.full_name as reviewer_name,

                   mgr.full_name as manager_name

            FROM documents d

            LEFT JOIN document_types dt ON d.type_id = dt.id

            LEFT JOIN users u ON d.uploaded_by = u.id

            LEFT JOIN review_assignments ra ON d.id = ra.document_id

            LEFT JOIN users rev ON ra.reviewer_id = rev.id

            LEFT JOIN users mgr ON ra.manager_id = mgr.id

            WHERE d.uploaded_by = %s

            ORDER BY d.id DESC

        """, (user['id'],))

        documents = cur.fetchall()



        cur.execute("SELECT id, full_name, role FROM users WHERE role = 'reviewer'")

        reviewers = cur.fetchall()



        cur.execute("SELECT id, full_name, role FROM users WHERE role = 'manager'")

        managers = cur.fetchall()



        cur.execute("SELECT COUNT(*) as count FROM documents WHERE uploaded_by = %s", (user['id'],))

        total_docs = cur.fetchone()['count']



        cur.execute("SELECT COUNT(*) as count FROM documents WHERE uploaded_by = %s AND status = 'approved'", (user['id'],))

        approved_docs = cur.fetchone()['count']



        cur.execute("""

            SELECT COUNT(*) as count FROM documents

            WHERE uploaded_by = %s AND status IN ('in_review', 'manager_review', 'final_review')

        """, (user['id'],))

        pending_final = cur.fetchone()['count']



    conn.close()

    return render_template(

        'user_dashboard.html',

        documents=documents,

        reviewers=reviewers,

        managers=managers,

        total_docs=total_docs,

        approved_docs=approved_docs,

        pending_final=pending_final

    )



@app.route('/upload', methods=['GET', 'POST'])

@login_required_custom

def upload_document():

    """Document Upload Step"""

    conn = get_db_connection()

    if request.method == 'POST':

        title = request.form['title']

        description = request.form.get('description', '')

        type_id = request.form.get('type_id')

        file = request.files.get('file')



        if file and allowed_file(file.filename):

            filename = secure_filename(file.filename)

            unique_name = f"{int(datetime.now().timestamp())}_{filename}"

            dest_path = os.path.join(app.config['UPLOAD_FOLDER'], unique_name)

            file.save(dest_path)



            with conn.cursor() as cur:

                cur.execute("""

                    INSERT INTO documents (title, description, file_path, file_name, current_version, type_id, uploaded_by, status)

                    VALUES (%s, %s, %s, %s, 'v1.0', %s, %s, 'submitted')

                """, (title, description, unique_name, filename, type_id, session['user']['id']))

                doc_id = cur.lastrowid



                cur.execute("""

                    INSERT INTO document_versions (document_id, version_number, file_path, file_name, uploaded_by, change_summary)

                    VALUES (%s, 'v1.0', %s, %s, %s, 'Initial document submission')

                """, (doc_id, unique_name, filename, session['user']['id']))



            conn.close()

            log_audit(doc_id, session['user']['id'], 'Document Uploaded', f"Uploaded {filename} as {title}")

            flash('Document uploaded successfully into DocFlow workflow!', 'success')

            return redirect(url_for('user_dashboard'))

        else:

            flash('Please upload a valid document file (PDF, DOCX, or Image).', 'danger')



    with conn.cursor() as cur:

        cur.execute("SELECT * FROM document_types")

        types = cur.fetchall()

    conn.close()

    return render_template('upload_document.html', types=types)



@app.route('/assign-reviewer', methods=['POST'])

@login_required_custom

def assign_reviewer():

    """Assign Reviewer & Manager with Deadline"""

    doc_id = request.form.get('document_id')

    reviewer_id = request.form.get('reviewer_id')

    manager_id = request.form.get('manager_id')

    deadline = request.form.get('deadline')



    conn = get_db_connection()

    with conn.cursor() as cur:

        cur.execute("SELECT id FROM review_assignments WHERE document_id = %s", (doc_id,))

        exists = cur.fetchone()



        if exists:

            cur.execute("""

                UPDATE review_assignments

                SET reviewer_id = %s, manager_id = %s, deadline = %s

                WHERE document_id = %s

            """, (reviewer_id, manager_id, deadline, doc_id))

        else:

            cur.execute("""

                INSERT INTO review_assignments (document_id, reviewer_id, manager_id, deadline, assigned_by)

                VALUES (%s, %s, %s, %s, %s)

            """, (doc_id, reviewer_id, manager_id, deadline, session['user']['id']))



        cur.execute("UPDATE documents SET status = 'in_review' WHERE id = %s", (doc_id,))



    conn.close()

    log_audit(doc_id, session['user']['id'], 'Reviewer Assigned', f"Reviewer ID: {reviewer_id}, Manager ID: {manager_id}")

    flash('Reviewer & Manager assigned successfully.', 'success')

    return redirect(url_for('user_dashboard'))



@app.route('/review/<int:doc_id>', methods=['GET', 'POST'])

@login_required_custom

def review_document(doc_id):

    """Split-Screen Document Review & Feedback"""

    user = session['user']

    conn = get_db_connection()



    if request.method == 'POST':

        decision = request.form.get('decision')

        notes = request.form.get('notes', '')



        with conn.cursor() as cur:

            cur.execute("SELECT status FROM documents WHERE id = %s", (doc_id,))

            current_status = cur.fetchone()['status']



            stage_name = 'reviewer'

            next_status = 'manager_review'



            if user['role'] == 'manager' or current_status == 'manager_review':

                stage_name = 'manager'

                next_status = 'final_review'

            elif user['role'] == 'admin' or current_status == 'final_review':

                stage_name = 'final_admin'

                next_status = 'approved'



            if decision == 'rejected':

                next_status = 'rejected'



            cur.execute("""

                INSERT INTO approvals (document_id, user_id, stage, decision, remarks)

                VALUES (%s, %s, %s, %s, %s)

            """, (doc_id, user['id'], stage_name, decision, notes))



            if notes:

                cur.execute("""

                    INSERT INTO comments (document_id, user_id, comment)

                    VALUES (%s, %s, %s)

                """, (doc_id, user['id'], notes))



            cur.execute("UPDATE documents SET status = %s WHERE id = %s", (next_status, doc_id))



        conn.close()

        log_audit(doc_id, user['id'], f"{stage_name.capitalize()} Decision: {decision}", notes)

        flash(f'Decision submitted: {decision.capitalize()}! Workflow updated.', 'success')

        return redirect(url_for('user_dashboard'))



    with conn.cursor() as cur:

        cur.execute("""

            SELECT d.*, dt.name as category_name, u.full_name as author_name

            FROM documents d

            LEFT JOIN document_types dt ON d.type_id = dt.id

            LEFT JOIN users u ON d.uploaded_by = u.id

            WHERE d.id = %s

        """, (doc_id,))

        doc = cur.fetchone()



        cur.execute("""

            SELECT c.*, u.full_name, u.role

            FROM comments c

            JOIN users u ON c.user_id = u.id

            WHERE c.document_id = %s

            ORDER BY c.created_at ASC

        """, (doc_id,))

        comments = cur.fetchall()



    conn.close()

    return render_template('review_document.html', doc=doc, comments=comments)



@app.route('/admin/dashboard')

@login_required_custom

def admin_dashboard():

    """Final Approval, Versioning & Audit Trail Console"""

    user = session['user']

    if user['role'] != 'admin':

        flash('Admin privilege required.', 'danger')

        return redirect(url_for('user_dashboard'))



    conn = get_db_connection()

    with conn.cursor() as cur:

        cur.execute("""

            SELECT d.*, dt.name as category_name, u.full_name as author_name

            FROM documents d

            LEFT JOIN document_types dt ON d.type_id = dt.id

            LEFT JOIN users u ON d.uploaded_by = u.id

            ORDER BY d.id DESC

        """)

        documents = cur.fetchall()



        cur.execute("""

            SELECT a.*, u.full_name as user_name, d.title as doc_title

            FROM audit_logs a

            LEFT JOIN users u ON a.user_id = u.id

            LEFT JOIN documents d ON a.document_id = d.id

            ORDER BY a.created_at DESC LIMIT 25

        """)

        audit_trail = cur.fetchall()



        cur.execute("SELECT COUNT(*) as count FROM documents WHERE status = 'approved'")

        approved_count = cur.fetchone()['count']



        cur.execute("SELECT COUNT(*) as count FROM documents WHERE status = 'final_review'")

        pending_final = cur.fetchone()['count']



    conn.close()

    return render_template(

        'admin_dashboard.html',

        documents=documents,

        audit_trail=audit_trail,

        approved_count=approved_count,

        pending_final=pending_final

    )



@app.route('/final-approval', methods=['POST'])

@login_required_custom

def final_approval():

    """Final approval action by admin"""

    doc_id = request.form.get('document_id')

    notes = request.form.get('approval_notes', 'Final Sign-off confirmed.')

    archive_flag = request.form.get('acknowledge_archive')



    status_target = 'archived' if archive_flag else 'approved'



    conn = get_db_connection()

    with conn.cursor() as cur:

        cur.execute("""

            INSERT INTO approvals (document_id, user_id, stage, decision, remarks)

            VALUES (%s, %s, 'final_admin', 'approved', %s)

        """, (doc_id, session['user']['id'], notes))



        cur.execute("UPDATE documents SET status = %s WHERE id = %s", (status_target, doc_id))

    conn.close()



    log_audit(doc_id, session['user']['id'], 'Final Approval Executed', f"Status set to {status_target}. Remarks: {notes}")

    flash(f"Final Approval completed! Document marked as {status_target.upper()}.", 'success')

    return redirect(url_for('admin_dashboard'))



@app.route('/audit-trail')

@login_required_custom

def audit_trail_view():

    conn = get_db_connection()

    with conn.cursor() as cur:

        cur.execute("""

            SELECT a.*, u.full_name as user_name, u.role, d.title as doc_title

            FROM audit_logs a

            LEFT JOIN users u ON a.user_id = u.id

            LEFT JOIN documents d ON a.document_id = d.id

            ORDER BY a.created_at DESC

        """)

        logs = cur.fetchall()

    conn.close()

    return render_template('audit_trail.html', logs=logs)



@app.route('/uploads/<path:filename>')

def serve_upload(filename):

    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)



if __name__ == '__main__':

    app.run(debug=True, port=5000) 