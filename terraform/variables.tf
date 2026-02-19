# Docker image info
variable "image_tag" {
  type        = string
  description = "Docker image tag from CI"
}

variable "dockerhub_repo" {
  type        = string
  description = "Docker Hub repo (username/repo)"
}

# ECS
variable "execution_role_arn" {
  type        = string
  description = "Existing ECS task execution role ARN"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for ECS + RDS subnet group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for ECS and security groups"
}

# RDS
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}


