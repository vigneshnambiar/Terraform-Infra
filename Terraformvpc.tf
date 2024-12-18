provider "aws" {
  region  = var.aws_region
  profile = "vignesh"
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

#Creating a New VPC

#Requirement
#1.Create a cidr for vpc
#2.Create a public and private subnets with the descired range with the required az
#3.Create IG
#4.Associate public subnets with the IG via routing table

resource "aws_vpc" "web" {
  cidr_block       = "10.1.0.0/16" #Changing to a different cidr range
  instance_tenancy = "default"

  tags = {
    Name = "TestVPC"
  }
}

#Subnet

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.web.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true          #Enabling auto assign of public ips
  cidr_block              = "10.1.1.0/24" #public

  tags = {
    Name                                 = "TestVPC-Public-Subnet1"
    "kubernetes.io/cluster/Test-cluster" = "owned"
    "kubernetes.io/role/elb"             = "1"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.web.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.1.16.0/20" #private
  map_public_ip_on_launch = false

  tags = {
    Name                                 = "TestVPC-Private-Subnet1"
    "kubernetes.io/cluster/Test-cluster" = "owned" #without this tag ingress controller is unable to auto assign the private subnet
    "kubernetes.io/role/internal-elb"    = "1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.web.id
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true           #Enabling auto assing of public IP, even during the console creation its disabled by default.
  cidr_block              = "10.1.10.0/24" #public

  tags = {
    Name                                 = "TestVPC-Public-Subnet2"
    "kubernetes.io/cluster/Test-cluster" = "owned"
    "kubernetes.io/role/elb"             = "1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.web.id
  availability_zone       = "us-east-1b"
  cidr_block              = "10.1.32.0/20" #private
  map_public_ip_on_launch = false

  tags = {
    Name                                 = "TestVPC-Private-Subnet2"
    "kubernetes.io/cluster/Test-cluster" = "owned" #without this tag ingress controller is unable to auto assign the private subnet
    "kubernetes.io/role/internal-elb"    = "1"
  }
}


#IG
resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name                                 = "VPC-Test-IG"
    "kubernetes.io/cluster/Test-cluster" = "owned" #without this tag ingress controller is unable to auto assign the private subnet
  }
}

#EIP for NAT
resource "aws_eip" "NGWEIP" {
  domain = "vpc"
  tags = {
    Name = "EIP for NAT"
  }
}

#NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.NGWEIP.id
  subnet_id     = aws_subnet.public1.id
}

#Routing table

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }

  tags = {
    Name = "VPC-test-rotetable"
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "VPC-test-privateroutetable"
  }
}

#Table assoctaion

resource "aws_route_table_association" "publica1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "publica2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.publicroute.id
}

#private table association
resource "aws_route_table_association" "privatea1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.privateroute.id
}

resource "aws_route_table_association" "privatea2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.privateroute.id
}
