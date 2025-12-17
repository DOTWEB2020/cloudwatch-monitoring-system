# IAM Role for CloudWatch
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-sns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "CloudWatch SNS Role"
    Project = var.project_name
  }
}

# IAM Policy for SNS Publishing
resource "aws_iam_role_policy" "cloudwatch_sns_policy" {
  name = "cloudwatch-sns-publish-policy"
  role = aws_iam_role.cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.cloudwatch_alerts.arn
      }
    ]
  })
}
