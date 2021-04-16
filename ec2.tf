data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "mlem-mlem" {
  count                = 1
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.mlem-mlem.name
  subnet_id            = aws_subnet.public[0]

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

resource "null_resource" "provision" {
  triggers = {
    env       = sha1(file("server-provision/.env"))
    bootstrap = sha1(file("server-provision/bootstrap.sh"))
    nginx     = sha1(file("server-provision/nginx.conf"))
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host        = aws_eip.ec2.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/ec2.key")
  }

  provisioner "file" {
    source      = "server-provision/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "file" {
    source      = "server-provision/.env"
    destination = "/tmp/.env"
  }

  provisioner "remote-exec" {
    script = "server-provision/bootstrap.sh"
  }
}

