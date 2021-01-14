data "aws_iam_policy_document" "ssm_lifecycle_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_lifecycle" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/aws:autoscaling:groupName"
      values   = [aws_autoscaling_group.asg.name]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = [aws_ssm_document.trigger_asg_stress.arn]
  }
}

resource "aws_iam_role" "ssm_lifecycle" {
  name               = "SSMLifecycle"
  assume_role_policy = data.aws_iam_policy_document.ssm_lifecycle_trust.json
}

resource "aws_iam_policy" "ssm_lifecycle" {
  name   = "SSMLifecycle"
  policy = data.aws_iam_policy_document.ssm_lifecycle.json
}

resource "aws_iam_role_policy_attachment" "ssm_lifecycle" {
  role       = aws_iam_role.ssm_lifecycle.name
  policy_arn = aws_iam_policy.ssm_lifecycle.arn
}

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
               "sudo stress -c 50 -v --timeout 450s"
            ]
         }
      }
   ]
}
DOC
}

resource "aws_cloudwatch_event_rule" "trigger_stress" {
  name                = "trigger-asg-stress"
  description         = "Triggers stress to run every 10 mins"
  schedule_expression = "rate(10 minutes)"
  tags                = var.standard_tags
}

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

