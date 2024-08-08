#creating security group for multiple resources

#jumpbox sec
resource "aws_security_group" "BastonHoste" {
  name        = "allow ssh and HTTP/HTTPS"
  description = "allow ssh and HTTP/HTTPS for testing"
  vpc_id      = aws_vpc.web.id

  ingress {
    description = "Allowing SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allowing HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allowing HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-security-grp"
  }
}


#private instance sec

resource "aws_security_group" "privatesg" {
  name        = "Private SG"
  description = "Allow only the incoming traffic from bastonhost"
  vpc_id      = aws_vpc.web.id

  ingress {
    description = "Allowing SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups =   [aws_security_group.BastonHoste.id] #mapping the baston sec group
  }

  tags = {
    Name = "Baston-Private-sg"
  }
}

