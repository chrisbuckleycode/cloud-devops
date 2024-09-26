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

```bash
$ python3 app.py
```

# To-Do

- Use python kubernetes client instead of subprocess. Will require a service & other resources.
