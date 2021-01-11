data "aws_ami" "my_ami" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "emmanuel-pius-ogiji-apache-ami"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "806310796880"]
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix = "emmanuel-pius-ogiji-lc-"
  image_id = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
  security_groups = [
    aws_security_group.allow_inbound_apache.id]
  user_data = file
  (
  "provision.sh"
  )


lifecycle {
  create_before_destroy = true
}
}

resource "aws_autoscaling_group" "asg" {
name = "emmanuel-pius-ogiji-asg"
launch_configuration = aws_launch_configuration.as_conf.name
desired_capacity = var.desired_capacity
min_size             = var.min_size
vpc_zone_identifier = [aws_subnet.main.id]
max_size = var.max_size

lifecycle {
create_before_destroy = true
}
}

resource "aws_autoscaling_policy" "agents-scale-up" {
name = "agents-scale-up"
scaling_adjustment = 1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "agents-scale-down" {
name = "agents-scale-down"
scaling_adjustment = -1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = aws_autoscaling_group.asg.name
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "my_elb" {
name = "emmanuel-pius-ogiji-elb"
availability_zones = data.aws_availability_zones.all.names
tags = var.standard_tags
health_check {
healthy_threshold = 2
unhealthy_threshold = 2
timeout = 3
interval = 30
target = "HTTP:80/"
}
listener {
lb_port = 80
lb_protocol = "http"
instance_port = "80"
instance_protocol = "http"
}
}