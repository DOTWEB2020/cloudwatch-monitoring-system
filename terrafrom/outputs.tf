output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.cloudwatch_alerts.arn
}

output "alarm_names" {
  description = "Names of created CloudWatch alarms"
  value = local.has_instances ? [
    aws_cloudwatch_metric_alarm.high_cpu[0].alarm_name,
    aws_cloudwatch_metric_alarm.high_network_in[0].alarm_name,
    aws_cloudwatch_metric_alarm.status_check_failed[0].alarm_name
  ] : []
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.cloudwatch_role.arn
}

output "monitored_instance_id" {
  description = "ID of the monitored EC2 instance"
  value       = local.has_instances ? local.instance_id : "No running instances found"
}
