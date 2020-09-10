data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = merge({ "Name" = "eks-vpc" }, local.default_tags)
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  count = var.subnet_count
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = merge({ "Name" = "eks-subnet" }, local.default_tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({ "Name" = "eks-igw" }, local.default_tags)
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge({ "Name" = "eks-rt" }, local.default_tags)
}

resource "aws_route_table_association" "rta" {
  count = var.subnet_count
  subnet_id = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "eks-master" {
  vpc_id = aws_vpc.vpc.id
  name = "eks-master-sg"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" = "eks-master-sg" }, local.default_tags)
}

resource "aws_security_group" "eks-node" {
  vpc_id = aws_vpc.vpc.id
  name = "eks-node-sg"

  ingress {
    description = "Allow cluster master to access cluster nodes"
    from_port = 1025
    to_port = 65535
    protocol = "tcp"
    security_groups = [aws_security_group.eks-master.id]
  }

  ingress {
    description = "Allow cluster master to access cluster nodes"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [aws_security_group.eks-master.id]
  }

  ingress {
    description = "Allow pods communicate each other"
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" = "eks-node-sg" }, local.default_tags)
}
