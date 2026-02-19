resource "aws_ecs_cluster" "prashanth_task7_cluster" {
  name = "prashanth-task7-strapi-cluster"
}

# -------------------------
# ALB Security Group
# -------------------------
resource "aws_security_group" "alb_sg" {
  name   = "prashanth-task7-alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# ECS Security Group
# -------------------------
resource "aws_security_group" "ecs_sg" {
  name   = "prashanth-task7-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# Load Balancer
# -------------------------
resource "aws_lb" "strapi_alb" {
  name               = "prashanth-task7-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
}

# -------------------------
# Target Group
# -------------------------
resource "aws_lb_target_group" "strapi_tg" {
  name        = "prashanth-task7-tg"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }
}

# -------------------------
# Listener
# -------------------------
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }
}

# -------------------------
# Task Definition
# -------------------------
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

# -------------------------
# ECS Service
# -------------------------
resource "aws_ecs_service" "prashanth_task7_service" {
  name            = "prashanth-task7-strapi-service"
  cluster         = aws_ecs_cluster.prashanth_task7_cluster.id
  task_definition = aws_ecs_task_definition.prashanth_task7_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "prashanth-task7-strapi-container"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.http_listener]
}

