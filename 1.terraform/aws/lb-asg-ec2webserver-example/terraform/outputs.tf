output "web_subnet_info" {
  value = {
    for idx, subnet in aws_subnet.web_subnets : idx => {
      name = subnet.id
      cidr = subnet.cidr_block
    }
  }
}

output "alb_web_dns_name" {
  value = aws_lb.alb-web.dns_name
}
