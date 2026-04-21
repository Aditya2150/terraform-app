resource "aws_ecr_repository" "repo" {
  name = var.image_name
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = var.retention_days
}

