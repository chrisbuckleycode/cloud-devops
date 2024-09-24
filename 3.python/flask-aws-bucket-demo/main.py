## FILE: flask-aws-bucket-demo/main.py
##
## DESCRIPTION: Flask (web-based) demo using the AWS SDK for Python (Boto3) to create/list/delete S3 buckets.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##

import boto3
import random
import string
from flask import Flask, request

# Initialize Flask app
app = Flask(__name__)

# Initialize S3 client
s3 = boto3.client('s3')

# HTML template for the index page
index_template = """
<!DOCTYPE html>
<html>
<head>
    <title>AWS S3 App</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <h1>AWS S3 App</h1>
    <div>
        <button id="list_buckets">List S3 Buckets</button>
        <button id="create_bucket">Create Bucket</button>
        <button id="delete_bucket" style="display:none">Delete Bucket</button>
    </div>
    <div id="response_section"></div>

    <script>
        $('#list_buckets').click(function() {
            $.get('/list_buckets', function(data) {
                $('#response_section').html(data);
                $('#delete_bucket').show();
            });
        });

        $('#create_bucket').click(function() {
            $.get('/create_bucket', function(data) {
                $('#response_section').text(data);
            });
        });

        $('#delete_bucket').click(function() {
            var bucketName = $("input[name='bucket']:checked").val();
            $.get('/delete_bucket?name=' + bucketName, function(data) {
                $('#response_section').html(data);
            });
        });
    </script>
</body>
</html>
"""

# Route to render the index page
@app.route('/')
def index():
    return index_template

# Route to list S3 buckets
@app.route('/list_buckets')
def list_buckets():
    buckets = [bucket['Name'] for bucket in s3.list_buckets()['Buckets']]
    if buckets:
        bucket_list = "\n".join([f"<div><input type='radio' name='bucket' value='{bucket}'> {bucket}</div>" for bucket in buckets])
        return bucket_list
    else:
        return "None"

# Route to create a random S3 bucket
@app.route('/create_bucket')
def create_bucket():
    bucket_name = 'test-' + ''.join(random.choices(string.ascii_lowercase + string.digits, k=12))
    s3.create_bucket(Bucket=bucket_name)
    return f"Bucket '{bucket_name}' created successfully!"

# Route to delete a selected S3 bucket
@app.route('/delete_bucket')
def delete_bucket():
    bucket_name = request.args.get('name')
    try:
        s3.delete_bucket(Bucket=bucket_name)
        return f"Bucket '{bucket_name}' deleted successfully."
    except Exception as e:
        return f"Error deleting bucket '{bucket_name}': {str(e)}"

if __name__ == '__main__':
    app.run()
