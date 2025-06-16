resource "aws_launch_template" "web" {
  name_prefix   = "web-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type

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
  desired_capacity    = 0 # Start with 0 instances
  max_size            = 4 # Maximum burst capacity
  min_size            = 0 # Let scaling policies control this
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

# Scale-out when CPU > 60% for 5 minutes
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

/* CloudWatch - enable if it fits the mean

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }
}
*/