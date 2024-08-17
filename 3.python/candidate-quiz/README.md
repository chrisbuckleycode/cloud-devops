# Candidate Quiz

This script is a web-based 10-question quiz for job candidates.

- Uses Flask.
- Welcome page followed by 10 single-question pages and a final result page.
- 10 second timer on each question.

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
$ python3 main.py
```

# To-Do

- Name submission and write scores to database.
- Prevent cheating.
