#Provider Configuration
provider "aws" {
  region = "us-east-1"
 enable_dns_hostnames = true
}

# VPC Creation

resource "aws_vpc" "vpc-lamp" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "LAMP-VPC"
  }
}


#Internet Gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc-lamp.id

  tags = {
    Name = "lamp-IG"
  }
}


# Public route table for web tier

resource "aws_route_table" "web-pub-rt" {
  vpc_id = aws_vpc.vpc-lamp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "web-public-rt"
  }
}

# Public web route table association

resource "aws_route_table_association" "public-rt-1" {
  route_table_id = aws_route_table.web-pub-rt.id
  subnet_id      = module.public_subnet_1.id
}

resource "aws_route_table_association" "public-rt-2" {
  route_table_id = aws_route_table.web-pub-rt.id
  subnet_id      = module.public_subnet_2.id
}

# Private Route Table for application

resource "aws_route_table" "app-pvt-rt" {
  vpc_id = aws_vpc.vpc-lamp.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app-nat.id
  }
  tags = {
    Name = "app-pvt-rt"
  }
}

# Private Application route table association

resource "aws_route_table_association" "app-rt-pvt-1" {
  route_table_id = aws_route_table.app-pvt-rt.id
  subnet_id      = module.private_subnet_1.id
}

resource "aws_route_table_association" "app-rt-pvt-2" {
  route_table_id = aws_route_table.app-pvt-rt.id
  subnet_id      = module.private_subnet_2.id
}


# Private Route Table for data tier

resource "aws_route_table" "db-pvt-rt" {
  vpc_id = aws_vpc.vpc-lamp.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.db-nat.id
  }
  tags = {
    Name = "db-pvt-rt"
  }
}

# databse private route table association

resource "aws_route_table_association" "db-rt-1" {
  route_table_id = aws_route_table.db-pvt-rt.id
  subnet_id      = module.database_subnet_1.id
}

resource "aws_route_table_association" "db-rt-2" {
  route_table_id = aws_route_table.db-pvt-rt.id
  subnet_id      = module.database_subnet_2.id
}


# Nat gateway for secured internet connectivity to private subnets , NOTE that this is created in public subnet

resource "aws_nat_gateway" "app-nat" {
  subnet_id     = module.public_subnet_1.id
  allocation_id = aws_eip.nat-eip.id

  tags = {
    Name = "app-nat"
  }

  depends_on = [aws_internet_gateway.ig]
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
}

# NAT gateway for secure internet connection database tier

resource "aws_nat_gateway" "db-nat" {
  subnet_id     = module.public_subnet_2.id
  allocation_id = aws_eip.db-eip.id
  tags = {
    Name = "DB-NAT"
  }

  depends_on = [aws_internet_gateway.ig]
}

resource "aws_eip" "db-eip" {
  domain = "vpc"
}
