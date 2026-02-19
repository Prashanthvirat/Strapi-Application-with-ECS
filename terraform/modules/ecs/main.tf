resource "aws_ecs_cluster" "prashanth_task7_cluster" {
  name = "prashanth-task7-strapi-cluster"
}

resource "aws_ecs_task_definition" "prashanth_task7_task" {
  family                   = "prashanth-task7-strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "prashanth-task7-strapi-container"
      image = "${var.dockerhub_repo}:${var.image_tag}"

      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]

      environment = [
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" },

        { name = "DATABASE_CLIENT", value = "postgres" },
        { name = "DATABASE_HOST", value = var.db_host },
        { name = "DATABASE_PORT", value = "5432" },
        { name = "DATABASE_NAME", value = var.db_name },
        { name = "DATABASE_USERNAME", value = var.db_username },
        { name = "DATABASE_PASSWORD", value = var.db_password },
        { name = "DATABASE_SSL", value = "false" }
      ]
    }
  ])
}

resource "aws_ecs_service" "prashanth_task7_service" {
  name            = "prashanth-task7-strapi-service"
  cluster         = aws_ecs_cluster.prashanth_task7_cluster.id
  task_definition = aws_ecs_task_definition.prashanth_task7_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
  }
}
