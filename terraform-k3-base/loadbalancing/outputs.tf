output "lb_target_group_arn" {
    value = aws_lb_target_group.myk3_target_group.arn
}

output "lb_endpoint" {
    value = aws_lb.myk3_load_balancer.dns_name
}