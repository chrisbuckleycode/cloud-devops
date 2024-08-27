output "public_subnet_info" {
  value = {
    for idx, subnet in aws_subnet.public_subnets : idx => {
      name     = subnet.id
      cidr     = subnet.cidr_block
    }
  }
}

output "private_subnet_info" {
  value = {
    for idx, subnet in aws_subnet.private_subnets : idx => {
      name     = subnet.id
      cidr     = subnet.cidr_block
    }
  }
}
