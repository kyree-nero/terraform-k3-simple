# --- compute/outputs.tf

output "instance" {
    value = aws_instance.myk3_node[*]
    sensitive = true
}

output "instance_port" {
    value = aws_lb_target_group_attachment.myk3_target_group_attach[0].port
}