from flask import Flask
app = Flask(__name__)

@app.route('/')
def root():
    return 'Root'

@app.route('/api')
def api():
    return 'API'

@app.route('/api/client')
def api_client():
    return 'API client'
