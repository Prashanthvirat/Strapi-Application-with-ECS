# Docker image info
variable "image_tag" {
  description = "Docker image tag from CI"
}

variable "dockerhub_repo" {
  description = "Docker Hub repo (username/strapi)"
}

# ECS
variable "execution_role_arn" {
  description = "Existing ECS task execution role ARN"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for ECS service"
}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

