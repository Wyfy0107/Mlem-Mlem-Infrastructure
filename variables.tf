variable "project" {
  description = "project name"

}

variable "environment" {
  description = "dev"
}

variable "region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "aws_access_key" {

}

variable "aws_secret_key" {

}

variable "domain_name" {
  description = "domain name"
}

variable "rds_password" {}

variable "rds_username" {}

variable "rds_engine" {}

variable "rds_instance_class" {}
variable "vpc_cidr" {
  description = "cidr block of the vpc"
}

variable "public_subnets_cidr" {
  description = "cidr blocks for public subnets"
  type        = list(string)
}

variable "ec2_port" {
  description = "server port in ec2"
}

variable "rds_port" {
  description = "server port for rds"
}

variable "route53_hosted_zone_id" {
  description = "hosted zone id of route53"
}

