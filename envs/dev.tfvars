# Infra-Level Variables

env        = "dev"
vpc_cidr   = "10.1.0.0/16"
aws_region = "us-east-2"


public_subnets = {
  "a" = {
    cidr = "10.1.1.0/24"
    az   = "us-east-2a"
  }
  "b" = {
    cidr = "10.1.2.0/24"
    az   = "us-east-2b"
  }
}


private_subnets = {
  "a" = {
    cidr = "10.1.11.0/24"
    az   = "us-east-2a"
  }
  "b" = {
    cidr = "10.1.12.0/24"
    az   = "us-east-2b"
  }
}


# Service-Level Variables

container_name   = "Flask_app"
container_cpu    = "256"
container_memory = "512"
container_count  = 3

image_name    = "flask_image"
image_version = "v1.0"

app_name            = "dev-app"
app_port            = 4000
app_protocol        = "HTTP"
logs_retention_days = 14
logs_region         = "us-east-2"

alb_listener_port     = 80
alb_listener_protocol = "HTTP"
