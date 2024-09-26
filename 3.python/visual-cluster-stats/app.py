## FILE: visual-cluster-stats/app.py
##
## DESCRIPTION: Flask (web-based) demo using subprocess to show realtime metrics derived from kubectl top nodes.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
## 
# TODO(chrisbuckleycode): Use Python Kubernetes client instead of subprocess. This requires a service & other resources.
# TODO(chrisbuckleycode): Ship as a full app i.e. with a Dockerfile and required Kubernetes resources.
#

from flask import Flask, render_template, jsonify
import subprocess
import time

app = Flask(__name__)

last_usage = (0, 0)

def get_cluster_usage():
    global last_usage
    try:
        result = subprocess.run(['kubectl', 'top', 'nodes'], capture_output=True, text=True)
        lines = result.stdout.strip().split('\n')
        if len(lines) < 2:
            return last_usage
        
        # Parse the second line (first line of data)
        _, _, cpu_percent, _, memory_percent = lines[1].split()
        
        cpu = float(cpu_percent.strip('%'))
        memory = float(memory_percent.strip('%'))
        
        last_usage = (cpu, memory)
        return cpu, memory
    except Exception:
        return last_usage

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/get_usage')
def get_usage():
    cpu, memory = get_cluster_usage()
    return jsonify({'cpu': cpu, 'memory': memory})

if __name__ == '__main__':
    app.run(debug=True)