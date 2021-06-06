# ----- loadbalancing/variables.tf

variable "public_subnets" {}
variable "public_security_group" {}
variable "target_group_port" {}
variable "target_protocol" {}
variable "vpc_id" {}
variable "lb_healthy_threshold" {}
variable "lb_unhealthy_threshold" {}
variable "lb_timeout" {}
variable "lb_interval" {}

variable "listener_port" {}
variable "listener_protocol" {}