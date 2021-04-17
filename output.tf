output "rds_dns" {
  value = aws_db_instance.mlem-mlem.endpoint
}

output "ec2_dns" {
  value = aws_eip.ec2.public_dns
}

output "ec2_ip" {
  value = aws_eip.ec2.public_ip
}

