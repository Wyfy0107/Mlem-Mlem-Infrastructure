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
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.mlem-mlem.name

  tags = {
    Name = "Mlem-Mlem-Server"
  }
}

resource "aws_iam_instance_profile" "mlem-mlem" {
  name = "mlem-mlem"
  role = aws_iam_role.mlem-mlem.name
}


