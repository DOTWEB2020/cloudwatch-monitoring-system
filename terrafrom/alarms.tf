# Get existing EC2 instances
data "aws_instances" "existing" {
  instance_state_names = ["running"]
}

# Local variable to check if instances exist
locals {
  has_instances = length(data.aws_instances.existing.ids) > 0
  instance_id   = local.has_instances ? data.aws_instances.existing.ids[0] : null
}

# CloudWatch Alarm - High CPU (only if instances exist)
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.has_instances ? 1 : 0  # Only create if instances exist

  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.alarm_threshold
  alarm_description   = "Triggers when CPU exceeds ${var.alarm_threshold}%"
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn]
  ok_actions          = [aws_sns_topic.cloudwatch_alerts.arn]

  dimensions = {
    InstanceId = local.instance_id
  }

  tags = {
    Name    = "High CPU Alarm"
    Project = var.project_name
  }
}

# CloudWatch Alarm - High Network In
resource "aws_cloudwatch_metric_alarm" "high_network_in" {
  count = local.has_instances ? 1 : 0

  alarm_name          = "high-network-in"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1000000000 # 1GB
  alarm_description   = "Network In traffic is high"
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn]

  dimensions = {
    InstanceId = local.instance_id
  }

  tags = {
    Name    = "High Network In Alarm"
    Project = var.project_name
  }
}

# CloudWatch Alarm - Status Check Failed
resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  count = local.has_instances ? 1 : 0

  alarm_name          = "ec2-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "EC2 instance status check failed"
  alarm_actions       = [aws_sns_topic.cloudwatch_alerts.arn]

  dimensions = {
    InstanceId = local.instance_id
  }

  tags = {
    Name    = "Status Check Alarm"
    Project = var.project_name
  }
}
