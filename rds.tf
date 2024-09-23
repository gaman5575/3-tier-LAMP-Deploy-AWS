# Subnet group for RDS database to connect to data base subnet

resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "db_subnet_group"
  subnet_ids = [module.database_subnet_1.id, module.database_subnet_2.id]

  tags = {
    Name = "Subnet group for database"
  }
}

# RDS database server for data 

resource "aws_db_instance" "data_db" {
  allocated_storage           = 10
  db_name                     = "DATA_db"
  engine                      = "mysql"
  engine_version              = "8.0.32"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true
  username                    = "admin"
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  skip_final_snapshot         = true
}