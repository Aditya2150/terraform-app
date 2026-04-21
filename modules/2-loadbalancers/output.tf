output "tg_arn" {
  description = "ID of the ALB Target Group ARN"
  value       = aws_lb_target_group.tg.arn
}

output "listener_arn" {
  description = "Load Balancer Listeners ARN"
  value       = aws_lb_listener.http.arn
}