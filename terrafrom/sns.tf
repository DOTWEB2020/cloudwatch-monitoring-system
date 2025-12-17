# SNS Topic for CloudWatch Alerts
resource "aws_sns_topic" "cloudwatch_alerts" {
  name         = "cloudwatch-alerts-topic"
  display_name = "AWS CloudWatch Alerts"

  tags = {
    Name        = "CloudWatch Alerts"
    Project     = var.project_name
    Environment = "Production"
  }
}

# SNS Email Subscription
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_alerts.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "cloudwatch_policy" {
  arn = aws_sns_topic.cloudwatch_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.cloudwatch_alerts.arn
      }
    ]
  })
}
