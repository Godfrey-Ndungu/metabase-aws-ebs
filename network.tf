locals {
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

data "aws_vpc" "app_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "app_subnet" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}


resource "aws_security_group" "postgres" {
  vpc_id      = var.vpc_id
  description = "Security group for DB"

  ingress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    description      = "Postgres DB access from within VPC"
    cidr_blocks      = local.cidr_blocks
    ipv6_cidr_blocks = local.ipv6_cidr_blocks
  }
  egress {
    from_port   = 0 
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = local.cidr_blocks
    ipv6_cidr_blocks = local.ipv6_cidr_blocks

  }

  tags = merge(var.default_tags, {
    name = "Postgres RDS"
  })
  
}
