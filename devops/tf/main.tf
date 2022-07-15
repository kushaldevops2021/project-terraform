

resource "aws_vpc" "devops11-vpc" {
   cidr_block = "172.0.0.0/26"
   instance_tenancy = "default"
   enable_dns_hostnames = "true"
   tags = merge(
     local.tags, 
     {
    Name = "devops11-vpc"     
     }
   )
}


resource "aws_subnet" "devops11-subnet-pub" {
    vpc_id = aws_vpc.devops11-vpc.id
    cidr_block = "172.0.0.0/28"
    availability_zone = "eu-west-2a"
    enable_resource_name_dns_a_record_on_launch = "true"
    map_public_ip_on_launch = "true"
    tags = merge(
     local.tags,
	 {
    Name = "devops11-vpc-pub-sub-1"
 	} )
}


resource "aws_subnet" "devops11-subnet-pvt" {
    vpc_id = aws_vpc.devops11-vpc.id
    cidr_block = "172.0.0.16/28"
    availability_zone = "eu-west-2b"
    enable_resource_name_dns_a_record_on_launch = "true"
    tags = merge(
     local.tags,
	{
    Name = "devops11-vpc-pvt-sub-1"
    })	
}

# Creating Internet Gateway

resource "aws_internet_gateway" "devops11-igw" {
 # vpc_id = aws_vpc.devops11-vpc.id

  tags = merge(
     local.tags,
	{
    Name = "devops11-igw"
  })
}

# Attaching internet gateway to vpc

resource "aws_internet_gateway_attachment" "devops11-igw-attach" {
  internet_gateway_id = aws_internet_gateway.devops11-igw.id
  vpc_id              = aws_vpc.devops11-vpc.id
}

# Creating route tables

resource "aws_route_table" "devops11-pub-rt" {
  vpc_id = aws_vpc.devops11-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops11-igw.id
  }


  tags = merge(
     local.tags,
    {	
    Name = "devops11-pub-RT"
  })
}

# creataing elastic ip
resource "aws_eip" "nat-eip" {
  vpc = true
}


resource "aws_nat_gateway" "devops11-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.devops11-subnet-pub.id

  tags = {
    Name = "devops11 NAT gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.devops11-igw]
}


resource "aws_route_table" "devops11-pvt-rt" {
  vpc_id = aws_vpc.devops11-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops11-nat.id     
  }


  tags = merge(
     local.tags,
    {
    Name = "devops11-pvt-RT"
  })
}

# creating security groups








/*
resource "aws_instance" "app_server" {
  ami           = "ami-0b5b266c2a7387f1f"
  instance_type = var.ec2-type
  key_name = var.key-name
  count = 1
  user_data = "user.tpl"
  tags = merge(
     local.tags,
	{
    Name = "server-${count.index}"
    name = "devops11"
  })
}
*/
