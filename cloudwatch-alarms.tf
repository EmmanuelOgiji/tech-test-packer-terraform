resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name          = "cpu-util-high-asg"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"
  alarm_description   = "This metric monitors ec2 for high CPU utilization"
  alarm_actions = [
    aws_autoscaling_policy.agents-scale-up.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_name          = "cpu-util-low-asg"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 for low CPU utilization"
  alarm_actions = [
    aws_autoscaling_policy.agents-scale-down.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}
