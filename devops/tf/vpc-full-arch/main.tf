resource "aws_subnet" "devops11-subnet-pub-1" {
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
resource "aws_subnet" "devops11-subnet-pub-2" {
    vpc_id = aws_vpc.devops11-vpc.id
    cidr_block = "172.0.0.16/28"
    availability_zone = "eu-west-2a"
    enable_resource_name_dns_a_record_on_launch = "true"
    map_public_ip_on_launch = "true"
    tags = merge(
     local.tags,
         {
    Name = "devops11-vpc-pub-sub-2"
        } )
}

# Creating private subnet
resource "aws_subnet" "devops11-subnet-pvt-1" {
    vpc_id = aws_vpc.devops11-vpc.id
    cidr_block = "172.0.0.32/28"
    availability_zone = "eu-west-2b"
    enable_resource_name_dns_a_record_on_launch = "true"
    tags = merge(
     local.tags,
        {
    Name = "devops11-vpc-pvt-sub-1"
    })
}
resource "aws_subnet" "devops11-subnet-pvt-2" {
    vpc_id = aws_vpc.devops11-vpc.id
    cidr_block = "172.0.0.48/28"
    availability_zone = "eu-west-2b"
    enable_resource_name_dns_a_record_on_launch = "true"
    tags = merge(
     local.tags,
        {
    Name = "devops11-vpc-pvt-sub-2"
    })
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
  subnet_id     = aws_subnet.devops11-subnet-pub-1.id

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

resource "aws_route_table_association" "sub-pub-1" {
  subnet_id      = aws_subnet.devops11-subnet-pub-1.id
  route_table_id = aws_route_table.devops11-pub-rt.id
}
resource "aws_route_table_association" "sub-pub-2" {
   subnet_id      = aws_subnet.devops11-subnet-pub-2.id
   route_table_id = aws_route_table.devops11-pub-rt.id
 }

resource "aws_route_table_association" "sub-pvt-1" {
  subnet_id      = aws_subnet.devops11-subnet-pvt-1.id
  route_table_id = aws_route_table.devops11-pvt-rt.id
}
resource "aws_route_table_association" "sub-pvt-2" {
   subnet_id      = aws_subnet.devops11-subnet-pvt-2.id
   route_table_id = aws_route_table.devops11-pvt-rt.id
 }
