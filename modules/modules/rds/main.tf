resource "aws_db_instance" "main" {
  identifier             = "prod-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = var.db_username  # Correct attribute name
  password               = var.db_password  # Correct attribute name
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  skip_final_snapshot    = true
  
  # Remove deprecated 'db_name' unless using MySQL/MariaDB
  # db_name = "mydb"  # Only for MySQL/MariaDB/PostgreSQL
}

resource "aws_db_subnet_group" "main" {
  name       = "db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = { Name = "db-subnet-group" }
}

resource "aws_security_group" "rds" {
  name_prefix = "rds-sg-"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.app_security_group_id]  # Pass from root
  }
}