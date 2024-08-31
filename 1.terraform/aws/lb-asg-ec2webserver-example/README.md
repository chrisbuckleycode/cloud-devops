# AWS LB-ASG-EC2(Webserver) Example

Creates:
- VPC, (public) subnets, IGW, routes (cut-down version of similar code: [vpc-public-private-example](../vpc-public-private-example/) 
- Load Balancer
- Auto Scaling group of EC2 instances running Apache web server.
- Security Groups

This is the "web-tier" only of [AWS's best practice architecture](./3TierArch.png)). This example is for http only (i.e. no https).

Configure variable `subnet_depth` to specify desired number of public/private subnet pairs.

Accessing the load-balancer endpoint on port 80 will display a page of instance metadata.

Note: Health checks work on a long timeout period and need to be refined.

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
$ terraform plan -out=planfile
$ terraform apply planfile
```

Look for output variable for load-balancer endpoint url to copy and paste into your browser address bar e.g.:
```
alb_web_dns_name = "alb-web-2103847519.us-east-1.elb.amazonaws.com"
```
Refresh to witness page serving from all instances.