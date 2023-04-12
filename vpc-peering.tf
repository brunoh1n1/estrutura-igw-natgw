resource "aws_vpc_peering_connection" "peer-gabi" {
  peer_vpc_id   = aws_vpc.vpc_nat_gateway.id
  vpc_id        = aws_vpc.vpc_internet_gateway.id
  auto_accept   = true
  tags = {
    Name = "VPC Peering between vpc-igw and vpc-natgw"
  }
}