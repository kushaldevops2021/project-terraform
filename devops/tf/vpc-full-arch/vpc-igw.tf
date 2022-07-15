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
