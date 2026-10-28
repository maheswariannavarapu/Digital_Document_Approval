import pymysql
from pymysql.cursors import DictCursor

MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'root',       # Enter your MySQL root password here (leave empty '' if none)
    'database': 'docflow_db',
    'port': 3306,
    'cursorclass': DictCursor,
    'autocommit': True
}

def get_db_connection():
    """Establishes connection to the MySQL database."""
    return pymysql.connect(
        host=MYSQL_CONFIG['host'],
        user=MYSQL_CONFIG['user'],
        password=MYSQL_CONFIG['password'],
        database=MYSQL_CONFIG['database'],
        port=MYSQL_CONFIG['port'],
        cursorclass=MYSQL_CONFIG['cursorclass'],
        autocommit=MYSQL_CONFIG['autocommit']
    )

def log_audit(document_id, user_id, action, details='', ip_address='127.0.0.1'):
    """Inserts an activity entry into the audit trail."""
    try:
        conn = get_db_connection()
        with conn.cursor() as cursor:
            sql = """
                INSERT INTO audit_logs (document_id, user_id, action, details, ip_address)
                VALUES (%s, %s, %s, %s, %s)
            """
            cursor.execute(sql, (document_id, user_id, action, details, ip_address))
        conn.close()
    except Exception as e:
        print(f"[Audit Log Error]: {e}")