variable "image_tag" {}
variable "dockerhub_repo" {}

variable "execution_role_arn" {}

variable "subnet_ids" {
  type = list(string)
}

variable "db_host" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
