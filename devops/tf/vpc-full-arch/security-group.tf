resource "aws_security_group" "devops11-pub-sg" {
  name        = "devops11-pub-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.devops11-vpc.id

  ingress {
    description      = "Allowing all ports"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops11-pub-sg"
  }
}

resource "aws_security_group" "devops11-pvt-sg" {
  name        = "devops11-pvt-sg"
  description = "Allow vpc traffic"
  vpc_id      = aws_vpc.devops11-vpc.id

  ingress {
    description      = "Allowing with in vpc"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["172.0.0.0/26"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops11-pvt-sg"
  }
}
