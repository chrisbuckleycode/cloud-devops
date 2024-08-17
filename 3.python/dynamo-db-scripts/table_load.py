import argparse
import boto3
import csv

def load_csv_to_dynamodb(table_name, csv_filename, num_records):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table(table_name)

    print(f"Loading data from the first {num_records} records of CSV file '{csv_filename}' into DynamoDB table '{table_name}'...")

    with open(csv_filename, 'r') as file:
        csv_reader = csv.reader(file)
        next(csv_reader)  # Skip the header row

        for idx, row in enumerate(csv_reader, start=1):
            if idx > num_records:
                break

            tweet_text = row[3]  # Assuming "Tweet Text" is the 4th column
            id_str = str(idx).zfill(6)  # Convert index to 6-digit string with leading zeroes
            table.put_item(Item={'id': id_str, 'Tweet': tweet_text})
            print(f"Inserted tweet with ID {id_str}: {tweet_text}")

    print("Data loading complete.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Load data from CSV into DynamoDB table')
    parser.add_argument('table_name', type=str, help='Name of the existing DynamoDB table')
    parser.add_argument('csv_filename', type=str, help='Path to the CSV file')
    parser.add_argument('num_records', type=int, help='Number of records to load')
    args = parser.parse_args()

    load_csv_to_dynamodb(args.table_name, args.csv_filename, args.num_records)
