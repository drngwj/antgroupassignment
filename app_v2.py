import os
from flask import Flask
app = Flask(__name__)

@app.route('/')
def os_info():
    return f"CPU Count: {os.cpu_count()}, System: {os.name}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)