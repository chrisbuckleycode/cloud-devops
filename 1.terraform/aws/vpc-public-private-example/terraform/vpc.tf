data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

locals {
  azs          = data.aws_availability_zones.available.names
  subnet_count = min(length(local.azs), var.subnet_depth)
}

resource "aws_subnet" "public_subnets" {
  count             = local.subnet_count
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = local.azs[count.index % length(local.azs)]
}

resource "aws_subnet" "private_subnets" {
  count             = local.subnet_count
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, var.subnet_depth + count.index)
  availability_zone = local.azs[count.index % length(local.azs)]
}

resource "aws_nat_gateway" "nat_gateways" {
  count         = local.subnet_count
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
}

resource "aws_eip" "nat_eips" {
  count  = local.subnet_count
  domain = "vpc"
}
