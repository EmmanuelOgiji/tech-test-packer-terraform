# SSM Document with command to run stress for 5 mins
resource "aws_ssm_document" "trigger_asg_stress" {
  name          = "trigger-asg-stress"
  document_type = "Command"

  content = <<DOC
  {
   "schemaVersion": "2.2",
   "description": "Trigger stress to increase CPU Utilization of instances",
   "parameters": {
    },
   "mainSteps": [
      {
         "action": "aws:runShellScript",
         "name": "RunStress",
         "inputs": {
            "runCommand": [
               "sudo stress -c 50 -v --timeout 300s"
            ]
         }
      }
   ]
}
DOC
}

# Eventbridge/Cloudwatch event rule to trigger every 10 mins
resource "aws_cloudwatch_event_rule" "trigger_stress" {
  name                = "trigger-asg-stress"
  description         = "Triggers stress to run every 10 mins"
  schedule_expression = "rate(10 minutes)"
  tags                = var.standard_tags
}

# Set Eventbridge/Cloudwatch event rule to run SSM command on ASG instances
resource "aws_cloudwatch_event_target" "trigger_stress" {
  target_id = "trigger-asg-stress"
  arn       = aws_ssm_document.trigger_asg_stress.arn
  rule      = aws_cloudwatch_event_rule.trigger_stress.name
  role_arn  = aws_iam_role.ssm_lifecycle.arn

  run_command_targets {
    key    = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.asg.name]
  }
}

#

