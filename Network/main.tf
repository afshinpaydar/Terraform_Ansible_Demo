#------------ VPC
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "frankfurt-vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "frankfurt-vpc"
    usage = "terraform"
  }
}

resource "aws_internet_gateway" "frankfurt-internet-gw" {
  vpc_id = aws_vpc.frankfurt-vpc.id
  tags = {
    Name = "frankfurt-igw"
    usage = "terraform"
  }
}

resource "aws_subnet" "primary" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id = aws_vpc.frankfurt-vpc.id
  cidr_block     = "10.10.0.0/20"
  tags = {
    Name = "frankfurt-subnet-1"
    usage = "terraform"
  }
}

resource "aws_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id = aws_vpc.frankfurt-vpc.id
  cidr_block     = "10.10.16.0/20"
  tags = {
    Name = "frankfurt-subnet-2"
    usage = "terraform"
  }
}

resource "aws_subnet" "tertiary" {
  availability_zone = data.aws_availability_zones.available.names[2]
  vpc_id = aws_vpc.frankfurt-vpc.id
  cidr_block     = "10.10.32.0/20"
  tags = {
    Name = "frankfurt-subnet-3"
    usage = "terraform"
  }
}

resource "aws_route_table" "rankfurt-rt" {
  vpc_id = aws_vpc.frankfurt-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.frankfurt-internet-gw.id
  }

  tags = {
    Name = "frankfurt-rt"
    usage = "terraform"
  }
}

resource "aws_main_route_table_association" "rankfurt-rt-association" {
  vpc_id = aws_vpc.frankfurt-vpc.id
  route_table_id = aws_route_table.rankfurt-rt.id
}

# ------ Security Group
resource "aws_security_group" "frankfurt-sg" {
  name        = "frankfurt-sg"
  description = "Allow Internal connectivity for frankfurt environment"
  vpc_id = aws_vpc.frankfurt-vpc.id

  tags = {
    Name = "frankfurt-sg"
    usage = "terraform"
  }
}

resource "aws_security_group" "frankfurt-sg-vpn" {
  name        = "frankfurt-sg-vpn"
  description = "Allow SSH to frankfurt VPN"
  vpc_id = aws_vpc.frankfurt-vpc.id

  tags = {
    Name = "frankfurt-sg-vpn"
    usage = "terraform"
  }
}

resource "aws_security_group" "frankfurt-sg-lb" {
  name        = "frankfurt-sg-lb"
  description = "Allow HTTP access from internet to frankfurt loadbalancer"
  vpc_id = aws_vpc.frankfurt-vpc.id

  tags = {
    Name = "frankfurt-sg-lb"
    usage = "terraform"
  }
}