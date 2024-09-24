# Flask AWS Bucket Demo

Flask (web-based) demo using the AWS SDK for Python (Boto3) to create/list/delete S3 buckets.

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
- Ensure you are authenticated to AWS via environment variables (fake example below):
```bash
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=us-east-1
```

# Usage

```bash
$ python3 main.py
```

# To-Do

- Move render template to a separate file if it grows significantly.
