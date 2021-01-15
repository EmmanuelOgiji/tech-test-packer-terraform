data "aws_iam_policy_document" "instance_profile_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance_profile_ssm" {
  name               = "instance-profile-ssm"
  assume_role_policy = data.aws_iam_policy_document.instance_profile_trust.json
}

resource "aws_iam_role_policy_attachment" "instance_profile_ssm" {
  role       = aws_iam_role.instance_profile_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "instance_profile_ssm" {
  name = "instance_profile_ssm"
  role = aws_iam_role.instance_profile_ssm.name
}

# Trust policy for IAM Role to allow Eventbridge trigger SSM
data "aws_iam_policy_document" "ssm_lifecycle_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

# IAM policy for IAM Role to allow Eventbridge trigger SSM
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

# IAM Role to allow Eventbridge trigger SSM
resource "aws_iam_role" "ssm_lifecycle" {
  name               = "SSMLifecycle"
  assume_role_policy = data.aws_iam_policy_document.ssm_lifecycle_trust.json
}

# Build IAM Policy to allow Eventbridge trigger SSM
resource "aws_iam_policy" "ssm_lifecycle" {
  name   = "SSMLifecycle"
  policy = data.aws_iam_policy_document.ssm_lifecycle.json
}

# Attach IAM policy to IAM Role to allow Eventbridge trigger SSM
resource "aws_iam_role_policy_attachment" "ssm_lifecycle" {
  role       = aws_iam_role.ssm_lifecycle.name
  policy_arn = aws_iam_policy.ssm_lifecycle.arn
}
