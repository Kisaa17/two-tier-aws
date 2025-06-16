resource "aws_launch_template" "web" {
  name_prefix   = "web-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  #key_name      = var.key_name

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    server_name = "MyWebServer"
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ec2_security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  vpc_zone_identifier = var.public_subnet_ids  # Spread across AZs

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]  # Attach to ALB

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}


resource "aws_security_group" "asg" {
  name_prefix = "asg-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]  # Allow ALB traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}