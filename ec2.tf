data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "mlem-mlem" {
  count                = 1
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.mlem-mlem.name
  subnet_id            = aws_subnet.public[count.index]

  vpc_security_group_ids = [aws_security_group.ec2.id]

  tags = {
    Name = "Mlem-Mlem-Server"
  }
}

resource "aws_iam_instance_profile" "mlem-mlem" {
  name = "mlem-mlem"
  role = aws_iam_role.mlem-mlem.name
}

resource "aws_eip" "ec2" {
  instance = aws_instance.mlem-mlem.id
  vpc      = true
}


