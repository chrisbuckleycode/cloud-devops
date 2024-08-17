import argparse
import boto3
from botocore.exceptions import ClientError

def check_table_exists(table_name):
    dynamodb = boto3.client('dynamodb', region_name='us-east-1')
    try:
        dynamodb.describe_table(TableName=table_name)
        return True
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            return False
        else:
            raise

def delete_all_records(table_name):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table(table_name)

    response = table.scan()
    with table.batch_writer() as batch:
        key_schema = table.key_schema
        for each in response.get('Items', []):
            key = {key_schema[0]['AttributeName']: each[key_schema[0]['AttributeName']]}
            batch.delete_item(Key=key)

def main():
    parser = argparse.ArgumentParser(description='Delete all records in a DynamoDB table')
    parser.add_argument('table_name', type=str, help='Name of the DynamoDB table to delete records from')
    args = parser.parse_args()

    if not check_table_exists(args.table_name):
        print(f"The table '{args.table_name}' does not exist.")
        return

    print(f"Summary: Deleting all records in the table '{args.table_name}'")
    confirmation = input("Please confirm by typing 'yes' and then pressing Enter: ")

    if confirmation.lower() != 'yes':
        print("Confirmation failed. Exiting.")
        return

    delete_all_records(args.table_name)
    print(f"All records in the table '{args.table_name}' have been deleted.")

if __name__ == "__main__":
    main()
