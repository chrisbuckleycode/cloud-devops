# Python DynamoDB Scripts

These scripts use the boto3 library to:
- Create a DynamoDB table
- Load it with data from a csv (Donald Trump tweets)
- Read a random record
- Delete all records in the table

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
- Prepare csv data to be added into DynamoDB e.g. Trump Tweets ([source](https://github.com/MarkHershey/CompleteTrumpTweetsArchive)). If using your own data, modify in the script the column(s) to be imported.
```bash
$ wget https://raw.githubusercontent.com/MarkHershey/CompleteTrumpTweetsArchive/master/data/realDonaldTrump_in_office.csv
```

# Usage

The example DynamoDB table referred to below is named 'trump-tweets'.

## table_create.py
Creates a DynamoDB table e.g.
```bash
$ table_create.py trump-tweets
```

## table_load.py
For a DynamoDB table, imports colum(s) and specified quantity of records (from top) e.g.
```bash
$ table_create.py trump-tweets realDonaldTrump_in_office.csv 150
```
See script to modify column(s) imported.

## table_read_random.py
Print a random tweet from the DynamoDB table e.g.
```bash
$ table_read_random.py trump-tweets
```

## table_records_delete.py
Delete all records in the DynamoDB table e.g.
```bash
$ table_records_delete.py trump-tweets
```

## Delete DynamoDB Table
Delete the table using the aws cli.
```bash
$ aws dynamodb delete-table –table-name trump-tweets
```
