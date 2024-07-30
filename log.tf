resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/${var.project_name}"
  retention_in_days = var.logs_retention_in_days
}
