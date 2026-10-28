import pymysql
from database import MYSQL_CONFIG

# 1. Connect using the exact credentials from your database.py, but without specifying the db
conn = pymysql.connect(
    host=MYSQL_CONFIG.get('host', 'localhost'),
    user=MYSQL_CONFIG.get('user', 'root'),
    password=MYSQL_CONFIG.get('password', ''),
    port=MYSQL_CONFIG.get('port', 3306),
    autocommit=True
)

cursor = conn.cursor()
print("Connected to MySQL Server.")

# 2. Read and run your schema.sql
with open('schema.sql', 'r', encoding='utf-8') as f:
    sql_script = f.read()

for stmt in sql_script.split(';'):
    command = stmt.strip()
    if command:
        cursor.execute(command)

print("Success: 'docflow_db' and all required tables have been created!")
cursor.close()
conn.close()