# GitHub Pipeline for Terraform

GitHub CI/CD Terraform pipeline:
- Plan & Apply Jobs
- Plan runs on PR open, Apply runs on PR merge to main.

## Instructions

Set secrets on repo:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `TF_BUCKET` (for state file and plan storage)

Copy `terraform.yml` to `.github/workflows`

## Future Ideas

- Store Terraform binary in own artifact repo/object storage (and compute checksum).
- Show plan in-line on PR page (instead of having to check pipeline logs).
- State file locking with DynamoDB.
