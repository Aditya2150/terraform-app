variable "app_name" {
  type    = string
  default = "flask_app"
}

variable "image_name" {
  type    = string
  default = "flask_image"
}
variable "image_version" {
  type    = string
  default = "latest"
}

variable "container_count" {
  type    = number
  default = 2
}
variable "container_name" {
  type    = string
  default = "flask"
}
variable "container_port" {
  type    = number
  default = 5000
}
variable "container_cpu" {
  type    = string
  default = "256"
}
variable "container_memory" {
  type    = string
  default = "512"
}

variable "retention_days" {
  type    = number
  default = 7
}
variable "logs_region" {
  type    = string
  default = "us-east-1"
}



variable "ecs_sg" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}


variable "tg_arn" {
  type = string
}

variable "listener_arn" {
  type = string
}