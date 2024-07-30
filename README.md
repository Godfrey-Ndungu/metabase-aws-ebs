# Metabase AWS Architecture

This guide will help you set up Metabase using AWS Elastic Beanstalk and Amazon RDS.

## Environment Variables

```hcl
    variable "aws_region" {
    description = "AWS Region"
    }

    variable "aws_profile" {
    default = "peach-default"
    }

    variable "project_name" {
    default     = "metabase"
    description = "Name of project"
    }

    variable "vpc_id" {}

    variable "subnet_a_id" {}

    variable "subnet_b_id" {}

    variable "aws_access_key" {}

    variable "aws_key_id" {}

    variable "logs_retention_in_days" {
    type        = number
    default     = 90
    description = "Specifies the number of days you want to retain log events"
    }

    variable "api_zone_id" {
    default     = ""
    description = "Zone ID for api"
    }

    variable "default_tags" {
    default = {
        name      = "Metabase"
        project   = "Metabase"
        terraform = "true"
    }
    }

    variable "create_db" {
    default     = true
    description = "Whether a new DB should be created"
    }

    variable "db_instance_class" {
    default = "db.t3.micro"
    }

    variable "db_storage_type" {
    default = "gp2"
    }

    variable "db_allocated_storage" {
    default = 20
    }

    variable "db_name" {}

    variable "db_host" {}

    variable "db_user" {}

    variable "db_password" {}

    variable "db_port" {
    default = "5432"
    }
```
### Useful Commands
List Available Elastic Beanstalk Solution Stacks
```hcl
aws elasticbeanstalk list-available-solution-stacks --region <your-aws-region>
```
List Available EBS Stacks

```hcl
aws elasticbeanstalk list-available-solution-stacks
```

## After Terraform Apply
Go to the Elastic Beanstalk environment
- Update and upload Dockerrun.aws.json
- Add SSL Using ACM
- Obtain an SSL certificate using AWS Certificate Manager (ACM).
- Configure the listener on port 443 to forward to port 80.

## Running Tests

To run tests, run the following command

```bash
  npm run test
```

