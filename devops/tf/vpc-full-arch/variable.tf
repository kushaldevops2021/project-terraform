variable "ec2-type" {
  type = string
  default = "t2.micro"
}

variable "key-name" {
  type = string
  default = "devops11"
}

variable "devops-region" {
  type = string
  description = "aws region"
  default = "eu-west-2"
}
