#!/bin/bash
##
## FILE: terraform-import-block-s3-buckets.sh
##
## DESCRIPTION: Retrieves bucket names using AWS CLI, then generates Terraform files required for resource import.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: terraform-import-block-s3-buckets.sh
##

# TODO(chrisbuckleycode): Create modified/additional resources based on AWS CLI bucket attribute lookup.
# TODO(chrisbuckleycode): Add check for AWS CLI authenticated.

echo "Fetching S3 bucket list..."

# Run the command and store the output in a variable
s3_output=$(aws s3 ls)

# Extract the bucket names and store them as variables
bucket_names=$(echo "$s3_output" | awk '{print $3}')

# Remove existing files if they exist
if [ -f "imports.tf" ]; then
  echo "Removing existing imports.tf file..."
  rm imports.tf
fi

if [ -f "buckets.tf" ]; then
  echo "Removing existing buckets.tf file..."
  rm buckets.tf
fi

if [ -f "provider.tf" ]; then
  echo "Removing existing provider.tf file..."
  rm provider.tf
fi

echo "Creating imports.tf file..."
# Create imports.tf file
touch imports.tf

# Loop through the bucket names and create the import blocks in imports.tf
for bucket_name in $bucket_names
do
  # Replace hyphens with underscores for the 'to' key
  to_key=$(echo $bucket_name | tr '-' '_')

  # Write the import block to imports.tf
  echo "import {" >> imports.tf
  echo "  to = aws_s3_bucket.$to_key" >> imports.tf
  echo "  id = \"$bucket_name\"" >> imports.tf
  echo "}" >> imports.tf
  echo "" >> imports.tf
done

echo "Creating buckets.tf file..."
# Create buckets.tf file
touch buckets.tf

# Loop through the bucket names and create the resource blocks in buckets.tf
for bucket_name in $bucket_names
do
  # Replace hyphens with underscores for the resource block name
  resource_name=$(echo $bucket_name | tr '-' '_')

  # Write the resource block to buckets.tf
  echo "resource \"aws_s3_bucket\" \"$resource_name\" {" >> buckets.tf
  echo "  bucket = \"$bucket_name\"" >> buckets.tf
  echo "}" >> buckets.tf
  echo "" >> buckets.tf
done

echo "Creating provider.tf file..."
# Create provider.tf file using heredoc syntax
cat << EOF > provider.tf
terraform {
  required_version = "~>1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
EOF

echo "Script execution completed."

echo ""
echo "Now run:"
echo "terraform init"
echo "terraform plan"
echo "terraform apply"
