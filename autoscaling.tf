data "aws_caller_identity" "current" {}

data "aws_ami" "my_ami" {
  most_recent = true

  filter {
    name = "name"
    values = [
    "emmanuel-pius-ogiji-apache-ami*"]
  }

  filter {
    name = "virtualization-type"
    values = [
    "hvm"]
  }

  owners = [data.aws_caller_identity.current.account_id]
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "emmanuel-pius-ogiji-lc-"
  image_id      = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
  security_groups = [
  aws_security_group.instance_sg.id]
  user_data = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "emmanuel-pius-ogiji-asg"
  launch_configuration      = aws_launch_configuration.as_conf.name
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  vpc_zone_identifier       = aws_subnet.main.*.id
  load_balancers            = [aws_elb.my_elb.name]
  max_size                  = var.max_size
  health_check_grace_period = 60
  health_check_type         = "ELB"

  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      "key"                 = "Owner"
      "value"               = "Emmanuel Pius-Ogiji"
      "propagate_at_launch" = true
    },
    {
      "key"                 = "Name"
      "value"               = "emmanuel-pius-ogiji-asg-instance"
      "propagate_at_launch" = true
    }
  ]
}

resource "aws_autoscaling_policy" "agents-scale-up" {
  name                   = "agents-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "agents-scale-down" {
  name                   = "agents-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_elb" "my_elb" {
  name            = "emmanuel-pius-ogiji-elb"
  subnets         = aws_subnet.main.*.id
  security_groups = [aws_security_group.instance_sg.id]
  tags            = var.standard_tags
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}