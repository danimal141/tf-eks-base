variable "region" {
  default = "ap-northeast-1"
}

variable "project" {
  default = "eks"
}

variable "environment" {
  default = "development"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  default = 2
}

variable "instance_type" {
  default = "t2.small"
}

variable "key_name" {
  # Override
  # Key name for EC2 instances
  # Can check `aws ec2 describe-key-pairs`
  default = "YOUR KEY NAME"
}

variable "asg_desired_capacity" {
  default = 2
}

variable "asg_max_size" {
  default = 2
}

variable "asg_min_size" {
  default = 2
}

locals {
  base_tags = {
    Project = var.project
    ManagedBy = "Terraform"
    Environment = var.environment
  }

  default_tags = merge(local.base_tags, map("kubernetes.io/cluster/${local.cluster_name}", "shared"))
  base_name = "${var.project}-${var.environment}"
  cluster_name = "${local.base_name}-cluster"
  cluster_version = "1.17"
}
