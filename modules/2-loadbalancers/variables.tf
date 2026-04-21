variable "app_name" {
  type    = string
  default = "flask_app"
}

variable "app_port" {
  type    = number
  default = 5000
}
variable "app_protocol" {
  type    = string
  default = "HTTP"
}

variable "alb_listener_port" {
  type    = number
  default = 80
}
variable "alb_listener_protocol" {
  type    = string
  default = "HTTP"
}




variable "vpc_id" {
  type = string
}

variable "alb_sg" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
