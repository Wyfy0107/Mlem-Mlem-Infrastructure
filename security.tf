resource "aws_security_group" "ec2" {
  name        = "ec2 security group"
  description = "security group for ec2"
  vpc_id      = aws_vpc.mlem-mlem.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = var.ec2_port
    to_port     = var.ec2_port
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }


  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
}

resource "aws_security_group" "rds" {
  name        = "rds security group"
  description = "security group for rds"
  vpc_id      = aws_vpc.mlem-mlem.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
}
