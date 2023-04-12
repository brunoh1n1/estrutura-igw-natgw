resource "aws_vpc" "vpc_nat_gateway" {
  cidr_block = "10.1.0.0/16"
  
  tags = {
    Name = "vpc_nat_gateway"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc_nat_gateway.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "public_subnet_natgw" {
  vpc_id     = aws_vpc.vpc_nat_gateway.id
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1a"
  
  tags = {
    Name = "public_subnet_natgw"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  
  tags = {
    Name = "elastic_ip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_natgw.id
  
  tags = {
    Name = "nat_gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_nat_gateway.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer-gabi.id
  }  
  
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_nat_gateway.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_natgw.id
  }
  
  tags = {
    Name = "public_route_table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_natgw.id
  route_table_id = aws_route_table.public_route_table.id
}





# attach internet gateway
resource "aws_internet_gateway" "internet_gateway_natgw" {
  vpc_id = aws_vpc.vpc_nat_gateway.id
  
  tags = {
    Name = "internet_gateway"
    Vpc = "nat_gateway"
  }
}
