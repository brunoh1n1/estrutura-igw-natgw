resource "aws_instance" "instance_igw" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = lookup(var.key, "name")
  vpc_security_group_ids = [aws_security_group.internet_sg.id]
  subnet_id     = aws_subnet.public_subnet_igw.id
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name 
  associate_public_ip_address = true
  tags = {
    Name = "EC2 Instance 1-internetGW"
  }
}

resource "aws_instance" "instance_natgw" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = lookup(var.key, "name")
  vpc_security_group_ids = [aws_security_group.nat_sg.id]
  subnet_id     = aws_subnet.private_subnet.id
  iam_instance_profile = aws_iam_instance_profile.dev-resources-iam-profile.name 
  tags = {
    Name = "EC2 Instance 2-natGW"
  }
}


resource "aws_key_pair" "aula" {
  key_name   = lookup(var.key, "name")
  public_key = lookup(var.key, "value")
}

resource "aws_key_pair" "aula_gabi2" {
  key_name   = lookup(var.key_gabi2, "name")
  public_key = lookup(var.key_gabi2, "value")
}
