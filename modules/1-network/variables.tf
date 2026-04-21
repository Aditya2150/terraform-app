variable "env" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "public_subnets" {
  default = {
    a = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    }

    b = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1b"
    }
  }
}

variable "private_subnets" {
  default = {
    a = {
      cidr = "10.0.11.0/24"
      az   = "us-east-1a"
    }

    b = {
      cidr = "10.0.12.0/24"
      az   = "us-east-1b"
    }
  }
}

variable "app_port" {
  type    = number
  default = 5000
}

variable "alb_listener_port" {
  type    = number
  default = 80
}
