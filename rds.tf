resource "aws_db_subnet_group" "default" {
  name       = "mlem-mlem-rds-subnet group"
  subnet_ids = aws_subnet.public.*.id

  tags = {
    Name = "mlem-mlem-db-subnet-group"
  }
}

resource "aws_db_instance" "mlem-mlem" {
  allocated_storage    = 5
  engine               = var.rds_engine
  storage_type         = "gp2"
  instance_class       = var.rds_instance_class
  identifier           = "${var.project}-mlem-mlem-${var.environment}"
  db_subnet_group_name = aws_db_subnet_group.default.name
  name                 = var.rds_db_name
  publicly_accessible  = true
  apply_immediately    = true

  vpc_security_group_ids = [aws_security_group.rds.id]

  password = var.rds_password
  port     = var.rds_port
  username = var.rds_username

  tags = {
    Name = "mlem-mlem-rds"
  }
}

