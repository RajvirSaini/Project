provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
 }


resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public1-cidr
  availability_zone = "ap-south-1a"  

  tags = {
    Name = var.subnet1-name
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private1-cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = var.subnet3-name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw-name
  }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = var.nateip-name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = var.nat-name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private-rt
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public" {
  name = "public-sg"
  description = "public security group"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.public-sg-name
  }
}

resource "aws_security_group_rule" "public_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group" "private" {
  name = "private-sg"
  description = "private security group"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.private-sg-name
  }
}

resource "aws_security_group_rule" "private_out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_in1" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [aws_subnet.public1.cidr_block]

  security_group_id = aws_security_group.private.id
}

resource "aws_instance" "public-instance" {
  count = 1
  instance_type = var.instance_type
  ami = var.ami
  vpc_security_group_ids = [aws_security_group.public.id]
  subnet_id = aws_subnet.public1.id
  associate_public_ip_address = true
  user_data = file("user-data")
  tags = {
    Name = var.instance-name
  }
}

resource "aws_launch_configuration" "aws_launch" {
  name   = var.aws-launch-name
  image_id      = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  user_data = file("user-data")
  security_groups = [aws_security_group.public.id]
}


resource "aws_autoscaling_group" "auto_group" {
  name                 = var.auto-name
  launch_configuration = aws_launch_configuration.aws_launch.name
  min_size = var.min-size
  max_size = var.max-size
  vpc_zone_identifier = [aws_subnet.public1.id]
  health_check_type = var.health-check-type
}
