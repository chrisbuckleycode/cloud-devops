# Visual Cluster Stats

Flask (web-based) demo using subprocess to show realtime metrics derived from kubectl top nodes.

# Pre-Requisites

- Clone this repo.

- Create and activate a virtual environment (install venv beforehand if required).
```bash
$ sudo apt install python3.10-venv
$ python3 -m venv .env
$ source .env/bin/activate
```
- Install required modules.
```bash
$ pip install -r requirements.txt
```

# Usage

This must be run directly on the node. Obviously, this is for demo/development purposes only and not production use.
```bash
$ python3 app.py
```

# To-Do

- Use Python Kubernetes client instead of subprocess. This requires a service & other resources.
- Ship as a full app i.e. with a Dockerfile and required Kubernetes resources.
