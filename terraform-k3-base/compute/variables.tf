variable "instance_count" {}

variable "instance_type" {}

variable "public_security_group" {}

variable "public_subnets" {}


variable "vol_size" {}
variable "public_key_path" {}
variable "key_name" {}
variable "user_data_path" {}

variable "dbuser" {}
variable "dbname" {}
variable "dbpassword" {}
variable "db_endpoint" {}
variable "lb_target_group_arn" {}

variable "target_group_port" {}

variable "private_key_path" {}