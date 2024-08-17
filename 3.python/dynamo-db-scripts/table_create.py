import boto3
import argparse

# Create a DynamoDB client
dynamodb = boto3.client('dynamodb', region_name='us-east-1')

# Define the key schema and attribute definitions
key_schema = [
    {
        'AttributeName': 'id',
        'KeyType': 'HASH'  # Partition key
    }
]

attribute_definitions = [
    {
        'AttributeName': 'id',
        'AttributeType': 'S'  # Assuming 'id' is a string attribute
    }
]

# Define the provisioned throughput
provisioned_throughput = {
    'ReadCapacityUnits': 1,  # Modified read capacity to 1
    'WriteCapacityUnits': 1  # Modified write capacity to 1
}

def create_dynamodb_table(table_name):
    # Check if the table already exists
    try:
        existing_tables = dynamodb.list_tables()['TableNames']
        if table_name in existing_tables:
            print(f'Table "{table_name}" already exists. Skipping table creation.')
        else:
            # Create the DynamoDB table
            response = dynamodb.create_table(
                TableName=table_name,
                KeySchema=key_schema,
                AttributeDefinitions=attribute_definitions,
                ProvisionedThroughput=provisioned_throughput
            )
            print(f'Table "{table_name}" created successfully.')
    except Exception as e:
        print(f'An error occurred: {str(e)}')

def main():
    parser = argparse.ArgumentParser(description='Create a DynamoDB table')
    parser.add_argument('table_name', type=str, help='Name of the DynamoDB table to create')
    args = parser.parse_args()

    create_dynamodb_table(args.table_name)

if __name__ == '__main__':
    main()
