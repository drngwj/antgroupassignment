from flask import Flask, request
import psycopg2

app = Flask(__name__)

# Database connection
conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="password",
    host="db"
)
cursor = conn.cursor()

@app.route('/')
def log_access():
    cursor.execute("INSERT INTO logs (path) VALUES (%s)", (request.path,))
    conn.commit()
    return "Logged Access!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)