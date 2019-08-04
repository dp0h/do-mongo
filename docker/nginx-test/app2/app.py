from flask import Flask
app = Flask(__name__)

@app.route('/')
def root():
    return 'Root App2'

@app.route('/api')
def api():
    return 'API app2'

@app.route('/api/client')
def api_client():
    return 'API client app2'

@app.route('/api/epg')
def api_epg():
    return 'epg app2'
