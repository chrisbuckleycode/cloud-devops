data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

locals {
  azs          = data.aws_availability_zones.available.names
  subnet_count = min(length(local.azs), var.subnet_depth)
}

resource "aws_subnet" "web_subnets" {
  count             = local.subnet_count
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = local.azs[count.index % length(local.azs)]
}

resource "aws_route_table" "web_subnets" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "web_subnets_internet_access" {
  route_table_id         = aws_route_table.web_subnets.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "web_subnets" {
  count          = var.subnet_depth
  subnet_id      = element(aws_subnet.web_subnets.*.id, count.index)
  route_table_id = aws_route_table.web_subnets.id
}
