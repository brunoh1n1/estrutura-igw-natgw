resource "aws_vpc" "vpc_internet_gateway" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "vpc_internet_gateway"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_internet_gateway.id
  
  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_subnet" "public_subnet_igw" {
  vpc_id     = aws_vpc.vpc_internet_gateway.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "public_subnet_igw"
  }
}

resource "aws_route_table" "public_route_table_iwg" {
  vpc_id = aws_vpc.vpc_internet_gateway.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer-gabi.id
  }  
  
  tags = {
    Name = "public_route_table_iwg"
  }
}

resource "aws_route_table_association" "public_route_table_iwg_association" {
  subnet_id      = aws_subnet.public_subnet_igw.id
  route_table_id = aws_route_table.public_route_table_iwg.id
}
