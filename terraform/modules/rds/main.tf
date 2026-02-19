resource "aws_db_subnet_group" "prashanth_task7_db_subnet_group" {
  name       = "prashanth-task7-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "prashanth_task7_db" {
  identifier        = "prashanth-task7-strapi-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name     = var.db_name
  username    = var.db_username
  password    = var.db_password

  publicly_accessible = true
  skip_final_snapshot = true
  deletion_protection = false

  db_subnet_group_name = aws_db_subnet_group.prashanth_task7_db_subnet_group.name
}

