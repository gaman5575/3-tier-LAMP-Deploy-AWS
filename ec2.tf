# Launch Bastion Host server

resource "aws_instance" "bastion_host" {
  ami                    = "ami-0a5c3558529277641"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = module.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]

  tags = {
    Name = "Bation_host"
  }
}

# Server for application

module "app_server_01" {
  source                 = "./modules/ec2"
  Name                   = "App-server-01"
  subnet_id              = module.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
}

module "app_server_02" {
  source                 = "./modules/ec2"
  Name                   = "App-server-02"
  subnet_id              = module.private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
}