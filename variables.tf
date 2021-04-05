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

variable "rds_password" {

}

variable "rds_username" {}

variable "rds_engine" {}
variable "rds_instance_class" {}
