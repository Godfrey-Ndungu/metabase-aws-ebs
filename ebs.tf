locals {
  app_env = {
    MB_DB_TYPE                      = "postgres"
    MB_DB_HOST                      = var.db_host
    MB_DB_DBNAME                    = var.db_name
    MB_DB_USER                      = var.db_user
    MB_DB_PORT                      = 5432
    MB_DB_PASS                      = var.db_password
  }
}

resource "aws_iam_role" "beanstalk_service" {
  name = "beanstalk_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "beanstalk_log_attach" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "beanstalk_iam_instance_profile" {
  name = "beanstalk_iam_instance_profile"
  role = aws_iam_role.beanstalk_service.name
}

resource "aws_elastic_beanstalk_application" "peach_metabase" {
  name        = "peach-metabase-ebs"
  description = "EBS Metabase"
}

resource "aws_elastic_beanstalk_environment" "peach_metabase_env" {
  name         = "peach-metabase-ebs"
  application  = aws_elastic_beanstalk_application.peach_metabase.name
  cname_prefix = "peach-metabase"

  solution_stack_name = "64bit Amazon Linux 2 v4.0.0 running Docker"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_iam_instance_profile.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "True"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.medium"
  }


  dynamic "setting" {
    for_each = local.app_env
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }
}
