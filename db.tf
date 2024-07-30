module "db" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "${var.project_name}-db"

  create_db_instance        = var.create_db
  create_db_parameter_group = var.create_db
  create_db_option_group    = var.create_db

  engine                = "postgres"
  engine_version        = "16.2"
  family                = "postgres16"
  major_engine_version  = "16"
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  storage_type          = var.db_storate_type
  max_allocated_storage = 100
  publicly_accessible   = true
  apply_immediately = true

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password
  port     = var.db_port

  multi_az = true
  subnet_ids =  [ var.subnet_a_id,
                  var.subnet_b_id,
                ]
  vpc_security_group_ids = [aws_security_group.postgres.id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = false
  backup_retention_period = 1
  skip_final_snapshot     = false
  deletion_protection     = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_role_name                  = "${var.project_name}-monitoring"
  monitoring_role_use_name_prefix       = true
  create_db_subnet_group                = true
  monitoring_interval                   = 60
  allow_major_version_upgrade = true

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    },
  ]

  db_option_group_tags = {
    "Sensitive" = "low"
  }

  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}

output "db_name" {
  value = module.db.db_instance_name
}

output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.db.db_instance_master_user_secret_arn
}

output "db_username" {
  value = module.db.db_instance_username
  sensitive = true
}
