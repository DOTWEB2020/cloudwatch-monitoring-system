variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "email_endpoint" {
  description = "Email for SNS notifications"
  type        = string
}

variable "alarm_threshold" {
  description = "CPU threshold for alarm"
  type        = number
  default     = 70
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "cloudwatch-monitoring"
}
