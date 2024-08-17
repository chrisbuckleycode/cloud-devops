import boto3
import argparse
import random
from botocore.exceptions import ClientError

# Initialize AWS service client for DynamoDB
dynamodb = boto3.client('dynamodb', region_name='us-east-1')

def get_random_tweet(table_name):
    try:
        response = dynamodb.scan(TableName=table_name)
        items = response['Items']
        
        random_item = random.choice(items)
        tweet = random_item.get('Tweet', {}).get('S')
        
        return tweet
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceNotFoundException':
            return f"Table '{table_name}' not found."
        else:
            return f"An error occurred: {e}"

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Retrieve a random Tweet from a DynamoDB table.')
    parser.add_argument('table_name', type=str, help='Name of the DynamoDB table to read')
    
    args = parser.parse_args()
    
    table_name = args.table_name
    
    random_tweet = get_random_tweet(table_name)
    
    print(random_tweet)
