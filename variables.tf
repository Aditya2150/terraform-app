variable "container_name" {
  type = string
}
variable "image_name" {
  type = string
}
variable "image_version" {
  type = string
}


variable "container_cpu" {
  type = string
}
variable "container_memory" {
  type = string
}

variable "app_name" {
  type = string
}
variable "container_count" {
  type = number
}
variable "app_port" {
  type = number
}
variable "app_protocol" {
  type = string
}

variable "alb_listener_port" {
  type = number
}
variable "alb_listener_protocol" {
  type = string
}

variable "logs_retention_days" {
  type = number
}
variable "logs_region" {
  type = string
}




variable "env" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "public_subnets" {
  type = map(map(string))
}

variable "private_subnets" {
  type = map(map(string))
}