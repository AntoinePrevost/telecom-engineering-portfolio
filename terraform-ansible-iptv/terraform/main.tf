#Configure aws provider
provider "aws" {
  region = "us-east-1"
  profile = "DevopsLab-708113109960"
}

#Read vpc resource 
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}