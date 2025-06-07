#Configure VPC resource
resource "aws_vpc" "practice_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"
  })
}

#Configure an Internet-Gateway
resource "aws_internet_gateway" "practice_igw" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

#Configure Subnets as required (Public, Private, and Backend)
resource "aws_subnet" "public_subnet_az_1a" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.public_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-az-1a"
  })
}

resource "aws_subnet" "public_subnet_az_1b" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.public_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-subnet-az-1b"
  })
}

resource "aws_subnet" "private_subnet_az_1a" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.private_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-az-1a"
  })
}

resource "aws_subnet" "private_subnet_az_1b" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.private_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-subnet-az-1b"
  })
}

resource "aws_subnet" "backend_subnet_az_1a" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.backend_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-az-1a"
  })
}

resource "aws_subnet" "backend_subnet_az_1b" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.backend_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-az-1b"
  })
}

# Configure Route table resource: Public Rt
resource "aws_route_table" "practice_public_rt" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.practice_igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}

# Configure Public Route table association
resource "aws_route_table_association" "practice_public_rt_association_az_1a" {
  subnet_id      = aws_subnet.public_subnet_az_1a.id
  route_table_id = aws_route_table.practice_public_rt.id
}

resource "aws_route_table_association" "practice_public_rt_association_az_1b" {
  subnet_id      = aws_subnet.public_subnet_az_1b.id
  route_table_id = aws_route_table.practice_public_rt.id
}

# CONFIGURATION FOR AZ-1A-----------
# Configure Elastic IP for Nat-Gateway in AZ-1a
resource "aws_eip" "practice_eip_az_1a" {
  domain   = "vpc"
}

# Configure Nat-gw in AZ-1a
resource "aws_nat_gateway" "practice_nat_gw_az_1a" {
  allocation_id = aws_eip.practice_eip_az_1a.id
  subnet_id     = aws_subnet.public_subnet_az_1a.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-1a"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.practice_igw]
}

# Configure Route table resource: Private Rt in AZ-1A
resource "aws_route_table" "practice_private_rt_az_1a" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.practice_nat_gw_az_1a.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-1a"
  })
}

# Configure Private Route table association in AZ-1A
resource "aws_route_table_association" "practice_private_rt_association_az_1a" {
  subnet_id      = aws_subnet.private_subnet_az_1a.id
  route_table_id = aws_route_table.practice_private_rt_az_1a.id
}

resource "aws_route_table_association" "practice_backend_rt_association_az_1a" {
  subnet_id      = aws_subnet.backend_subnet_az_1a.id
  route_table_id = aws_route_table.practice_private_rt_az_1a.id
}

# CONFIGURATION FOR AZ-1B-----------
# Configure Elastic IP for Nat-Gateway in AZ-1b
resource "aws_eip" "practice_eip_az_1b" {
  domain   = "vpc"
}

# Configure Nat-gw in AZ-1b
resource "aws_nat_gateway" "practice_nat_gw_az_1b" {
  allocation_id = aws_eip.practice_eip_az_1b.id
  subnet_id     = aws_subnet.public_subnet_az_1b.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az-1b"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.practice_igw]
}

# Configure Route table resource: Private Rt in AZ-1B
resource "aws_route_table" "practice_private_rt_az_1b" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.practice_nat_gw_az_1b.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az-1a"
  })
}

# Configure Private Route table association in AZ-1B
resource "aws_route_table_association" "practice_private_rt_association_az_1b" {
  subnet_id      = aws_subnet.private_subnet_az_1b.id
  route_table_id = aws_route_table.practice_private_rt_az_1b.id
}

resource "aws_route_table_association" "practice_backend_rt_association_az_1b" {
  subnet_id      = aws_subnet.backend_subnet_az_1b.id
  route_table_id = aws_route_table.practice_private_rt_az_1b.id
}