resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair"
  public_key = tls_private_key.key_info.public_key_openssh
}

resource "tls_private_key" "key_info" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key_pair_file" {
  content  = tls_private_key.key_info.private_key_pem
  filename = "lamp_key_pair"
}