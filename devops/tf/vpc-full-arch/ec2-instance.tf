resource "aws_instance" "app_server-pub-1" {
  subnet_id =aws_subnet.devops11-subnet-pub-1.id
  security_groups =[aws_security_group.devops11-pub-sg.id]
  ami           = "ami-0b5b266c2a7387f1f"
  
  instance_type = var.ec2-type
  key_name = var.key-name
  user_data = "user.tpl"
  tags = merge(
     local.tags,
        {
    Name = "pub-ec2-1"
    name = "devops11"
  })
}
resource "aws_instance" "app_server-pub-2" {
  subnet_id =aws_subnet.devops11-subnet-pub-2.id
  security_groups =[aws_security_group.devops11-pub-sg.id]
  ami           = "ami-0b5b266c2a7387f1f"

  instance_type = var.ec2-type
  key_name = var.key-name
  user_data = "user.tpl"
  tags = merge(
     local.tags,
        {
    Name = "pub-ec2-2"
    name = "devops11"
  })
}

resource "aws_instance" "app_server-pvt" {
  subnet_id =aws_subnet.devops11-subnet-pvt-1.id
  security_groups =[aws_security_group.devops11-pvt-sg.id]
  ami           = "ami-0b5b266c2a7387f1f"
  
  instance_type = var.ec2-type
  key_name = var.key-name
  count = 2
  user_data = "user.tpl"
  tags = merge(
     local.tags,
        {
    Name = "pvt-ec2-${count.index}"
    name = "devops11"
  })
}

