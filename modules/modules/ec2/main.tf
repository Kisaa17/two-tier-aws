# Public EC2 Instances (one per public subnet)
resource "aws_instance" "public" {
  count                  = length(var.public_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.public.id]
  associate_public_ip_address = true

  tags = {
    Name = "public-instance-${count.index}"
  }
}

# Private EC2 Instances (one per private subnet)
/*
resource "aws_instance" "private" {
  count                  = length(var.private_subnet_ids)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.private.id]
  associate_public_ip_address = false

  tags = {
    Name = "private-instance-${count.index}"
  }
}
*/


# Security Groups
resource "aws_security_group" "public" {
  name_prefix = "public-sg-"
  vpc_id      = var.vpc_id
  # Allow SSH/HTTP (customize as needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private" {
  name_prefix = "private-sg-"
  vpc_id      = var.vpc_id
  # Allow internal traffic only
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


#register EC2 instance with target group
resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.public)
  target_group_arn = var.target_group_arn  # Passed from ALB module
  target_id        = aws_instance.public[count.index].id
}