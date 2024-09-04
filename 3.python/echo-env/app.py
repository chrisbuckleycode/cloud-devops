from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def display_env_vars():
    env_vars = [f"{key}: {value}" for key, value in os.environ.items()]
    return '<br>'.join(env_vars)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
