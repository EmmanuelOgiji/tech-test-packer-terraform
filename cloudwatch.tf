# Cloudwatch alarm for scale up action (HighCPU)
resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name          = "cpu-util-high-asg"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.upper_cpu_threshold
  alarm_description   = "This metric monitors ec2 for high CPU utilization"
  alarm_actions = [
    aws_autoscaling_policy.agents-scale-up.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

# Cloudwatch alarm for scale down action (LowCPU)
resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_name          = "cpu-util-low-asg"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.alarm_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.lower_cpu_threshold
  alarm_description   = "This metric monitors ec2 for low CPU utilization"
  alarm_actions = [
    aws_autoscaling_policy.agents-scale-down.arn
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

# Cloudwatch dashboard to monitor number of Instances in Autoscaling Group
resource "aws_cloudwatch_dashboard" "asg_instances" {
  dashboard_name = "emmanuel-pius-ogiji-instances-in-service"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "width": 18,
      "height": 6,
      "start": "-PT3H",
      "end": "P0D",
      "properties": {
        "metrics": [
          [
            "AWS/AutoScaling",
            "GroupInServiceInstances",
            "AutoScalingGroupName",
            "${aws_autoscaling_group.asg.name}"
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "period": 60,
        "stat": "Maximum",
        "region": "${var.region}",
        "title": "emmanuel-pius-ogiji-instances-in-service"
      }
    }
  ]
}
EOF
}
