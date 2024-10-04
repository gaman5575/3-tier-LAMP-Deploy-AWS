

# Module template for private application servers

resource "aws_instance" "web_servers" {
  ami = "ami-0a5c3558529277641"
  instance_type = "t2.micro"
  key_name = "key_pair"
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data = "${file("${path.module}/service.sh")}"

  tags = {
    Name = var.Name
  }
}
