//--- networking/main.tf

data "aws_availability_zones" "available"{}

resource "random_shuffle" "az_list" {
    input = data.aws_availability_zones.available.names
    result_count = var.max_subnets
}
resource "random_integer" "random"{
    min = 1
    max = 100
}

resource "aws_vpc" "myk3_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "myk3_vpc-${random_integer.random.id}"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_subnet" "myk3_public_subnet" {
    #count = length(var.public_cidrs)
    count = var.public_sn_count
    vpc_id = aws_vpc.myk3_vpc.id
    cidr_block = var.public_cidrs[count.index]
    map_public_ip_on_launch = true
    #availability_zone = ["us-east-2a", "us-east-2b", "us-east-2c"][count.index]
    #availability_zone = data.aws_availability_zones.available.names[count.index]
    availability_zone = random_shuffle.az_list.result[count.index]
    tags = {
        Name = "myk3_public_subnet-${count.index + 1}"
    }
}


resource "aws_subnet" "myk3_private_subnet" {
    #count = length(var.private_cidrs)
    count = var.private_sn_count
    vpc_id = aws_vpc.myk3_vpc.id
    cidr_block = var.private_cidrs[count.index]
    #availability_zone = ["us-east-2a", "us-east-2b", "us-east-2c"][count.index]
    #availability_zone = data.aws_availability_zones.available.names[count.index]
    availability_zone = random_shuffle.az_list.result[count.index]
    tags = {
        Name = "myk3_private_subnet-${count.index + 1}"
    }
}

resource "aws_route_table_association" "myk3_public_association" {
    count = var.public_sn_count
    subnet_id = aws_subnet.myk3_public_subnet.*.id[count.index]
    route_table_id = aws_route_table.myk3_public_route_table.id
}

resource "aws_internet_gateway" "myk3_internet_gateway"{
    vpc_id = aws_vpc.myk3_vpc.id

    tags = {
      "Name" = "myk3_internet_gateway"
    }
}

resource "aws_route_table" "myk3_public_route_table"{
    vpc_id = aws_vpc.myk3_vpc.id

    tags = {
      "Name" = "myk3_route_table"
    }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.myk3_public_route_table.id
    destination_cidr_block =  "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myk3_internet_gateway.id
}

resource "aws_default_route_table" "myk3_private_route_table" {
    default_route_table_id = aws_vpc.myk3_vpc.default_route_table_id

    tags = {
      "Name" = "myk3_private_route_table"
    }
}

resource "aws_security_group" "myk3_security_group" {
    for_each = var.security_groups
    
    #name = "public_security_group"
    name = each.value.name
    #description =  "Security Group for Public Access"
    description = each.value.description

    vpc_id = aws_vpc.myk3_vpc.id

    # ingress {
    #     from_port = 22
    #     to_port = 22
    #     protocol = "tcp"
    #     cidr_blocks = [var.access_ip]
    # }
    dynamic "ingress" {
        for_each = each.value.ingress
        content {
            from_port = ingress.value.from
            to_port = ingress.value.to
            protocol = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_db_subnet_group" "myk3_rds_subnet_group" {
    count = var.db_subnet_group == true ? 1 : 0
    name = "myk3_rds_subnet_group"
    subnet_ids = aws_subnet.myk3_private_subnet.*.id
    tags = {
        Name = "myk3_rds_subnet_group"
    }
}