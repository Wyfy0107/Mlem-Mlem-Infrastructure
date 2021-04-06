resource "aws_route53_record" "mlme-mlem" {
  zone_id         = var.route53_hosted_zone_id
  name            = var.domain_name
  type            = "A"
  ttl             = "300"
  records         = [aws_eip.ec2.public_ip]
  allow_overwrite = true
}
