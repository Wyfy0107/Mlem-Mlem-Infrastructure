resource "aws_db_instance" "mlem-mlem" {
  allocated_storage = 5
  engine            = var.rds_engine
  storage_type      = "gp2"
  instance_class    = var.rds_instance_class
  identifier        = "${var.project}-mlem-mlem-${var.environment}"

  password = var.rds_password
  port     = 5432
  username = var.rds_username

  tags = {
    Name = "mlem-mlem-rds"
  }
}
