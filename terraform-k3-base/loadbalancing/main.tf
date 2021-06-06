# --- lb/main.tf

resource "aws_lb" "myk3_load_balancer" {
    name = "myk3-load-balancer"
    subnets = var.public_subnets
    security_groups = [var.public_security_group]
    idle_timeout = 400
}

resource "aws_lb_target_group" "myk3_target_group" {
    name = "myk3-load-balancer-${substr(uuid(), 0, 3)}"
    port = var.target_group_port
    protocol = var.target_protocol
    vpc_id = var.vpc_id
    lifecycle {
        ignore_changes = [name]
        create_before_destroy = true
    }
    health_check {
      healthy_threshold = var.lb_healthy_threshold
      unhealthy_threshold =  var.lb_healthy_threshold
      timeout = var.lb_timeout
      interval = var.lb_interval
    }
}

resource "aws_lb_listener" "myk3_lb_listener" {
    load_balancer_arn =  aws_lb.myk3_load_balancer.arn
    port = var.listener_port
    protocol = var.listener_protocol
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.myk3_target_group.arn
    }
}