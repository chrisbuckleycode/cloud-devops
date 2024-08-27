# AWS VPC Public-Private Example

Creates:
- VPC
- IGW
- For each azone: a public subnet (with NAT gateway), a private subnet

Configure variable `subnet_depth` to specify desired number of public/private subnet pairs.

## Instructions

Don't forget to authenticate to AWS e.g.

```
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=us-east-1
```

Run the usual Terraform commands.

```
$ terraform init
$ terraform plan out=planfile
$ terraform apply planfile
```