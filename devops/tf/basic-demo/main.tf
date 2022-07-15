terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}
resource "aws_instance" "app_server" {
  ami           = "ami-0b5b266c2a7387f1f"
  instance_type = "t2.micro"
  key_name = "devops11"
  count = 3
  user_data = "user.tpl"
  tags = {
    Name = "server-${count.index}"
    name = "devops11"
  }
}
