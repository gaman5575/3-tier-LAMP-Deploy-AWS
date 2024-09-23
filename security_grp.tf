# Security group for application tier servers

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for web and app servers"
  vpc_id      = aws_vpc.vpc-lamp.id

  ingress {
    description     = "SSH into instance through Baston Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }

  ingress {
    description     = "Allow connection to load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.app_lb_sg.id]
  }

  egress {
    description = "Alow all Outbound Connectivity"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "app_sg"
  }
}



# Security Group for database servers

resource "aws_security_group" "db_sg" {
  description = "Allow application servers to communicate to db servers"
  name        = "db_sg"
  vpc_id      = aws_vpc.vpc-lamp.id

  ingress {
    description     = "Connection to database"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  tags = {
    Name = "db_sg"
  }

}


# Security group for load balancer web servers

resource "aws_security_group" "app_lb_sg" {
  name        = "app_lb_sg"
  description = "Security group for load balancer on the web and app servers"
  vpc_id      = aws_vpc.vpc-lamp.id

  ingress {
    description = "To Access web server"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound connectivity for all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_lb_sg"
  }
}


# Security group for Bastion Host server

resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion_host_sg"
  description = "Security Group for bastion host on the web tier"
  vpc_id      = aws_vpc.vpc-lamp.id

  ingress {
    description = "SSH into server"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_host_sg"
  }
}