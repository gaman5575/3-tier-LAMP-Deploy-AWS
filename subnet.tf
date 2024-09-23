module "public_subnet_1" {
  Name                    = "web-public-AZ1"
  source                  = "./modules/subnet"
  vpc_id                  = aws_vpc.vpc-lamp.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

module "public_subnet_2" {
  Name                    = "web-public-AZ2"
  source                  = "./modules/subnet"
  vpc_id                  = aws_vpc.vpc-lamp.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}


module "private_subnet_1" {
  Name              = "app-private-AZ1"
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.vpc-lamp.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1a"
}

module "private_subnet_2" {
  Name              = "app-private-AZ2"
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.vpc-lamp.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-1b"
}


module "database_subnet_1" {
  Name              = "db-private-AZ1"
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.vpc-lamp.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-1a"
}

module "database_subnet_2" {
  Name              = "db-private-AZ2"
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.vpc-lamp.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "us-east-1b"
}