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
  subnet_id            = aws_subnet.public[0].id
  key_name             = aws_key_pair.mlem-mlem.key_name

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
  instance = aws_instance.mlem-mlem[0].id
  vpc      = true
}

data "template_file" "env" {
  template = file("${path.module}/server-provision/.env")
  vars = {
    db_host     = aws_db_instance.mlem-mlem.address
    db_password = var.rds_password
    db_username = var.rds_username
    db_name     = var.rds_db_name
  }
}

data "template_file" "bootstrap" {
  template = file("${path.module}/server-provision/bootstrap.sh")
  vars = {
    certbot_email  = var.certbot_email
    certbot_domain = var.certbot_domain
  }
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
    content     = data.template_file.env.rendered
    destination = "/tmp/.env"
  }

  provisioner "file" {
    content     = data.template_file.bootstrap.rendered
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh"
    ]
  }
}

resource "aws_key_pair" "mlem-mlem" {
  key_name   = "ssh key"
  public_key = file("${path.module}/ec2.key.pub")
}
