# K8s Utils

Various Kubernetes command-line utilities

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

## backup_github_repos.py
Displays pod CPU statistics for a specified namespace: current CPU, running average CPU, CPU requests (if any).
```bash
$ python3 pod-cpu-average.py <namespace>
```

# To-Do
