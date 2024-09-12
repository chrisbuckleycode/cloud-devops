#!/bin/bash
##
## FILE: aws-s3-buckets-delete.sh
##
## DESCRIPTION: Retrieves bucket names and deletes each bucket one by one, all using AWS CLI.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: aws-s3-buckets-delete.sh
##
## NOTE: This script is the same as one-liners:
##       for bucket_name in $(aws s3 ls | awk '{print $3}'); do aws s3 rb s3://$bucket_name --force; done
##       OR:
##       aws s3 ls | awk '{print $3}' | xargs -I {} aws s3 rb s3://{} --force

# TODO(chrisbuckleycode): Add check for AWS CLI authenticated.

# Get a list of all S3 bucket names
bucket_list=$(aws s3 ls | awk '{print $3}')

echo "The following S3 buckets will be deleted:"
echo "$bucket_list"

read -p "Press Enter to continue or Ctrl+C to cancel..."

# Loop through each bucket and delete it
for bucket_name in $bucket_list
do
    echo "Deleting bucket: $bucket_name"
    aws s3 rb s3://$bucket_name --force
done

echo "All S3 buckets have been deleted."
