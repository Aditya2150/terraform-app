module "networking" {
  source = "./modules/1-network"

  env               = var.env
  vpc_cidr          = var.vpc_cidr
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets
  app_port          = var.app_port
  alb_listener_port = var.alb_listener_port
}



module "load_balancer" {
  source = "./modules/2-loadbalancers"

  app_name              = var.app_name
  app_port              = var.app_port
  app_protocol          = var.app_protocol
  alb_listener_port     = var.alb_listener_port
  alb_listener_protocol = var.alb_listener_protocol

  vpc_id         = module.networking.vpc_id
  alb_sg         = module.networking.alb_sg_id
  public_subnets = module.networking.public_subnet_id_list
}



module "ecs" {
  source = "./modules/3-ecs"

  app_name         = var.app_name
  container_count  = var.container_count
  image_name       = var.image_name
  image_version    = var.image_version
  container_name   = var.container_name
  container_port   = var.app_port
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  retention_days   = var.logs_retention_days
  logs_region      = var.logs_region

  ecs_sg          = module.networking.ecs_sg_id
  tg_arn          = module.load_balancer.tg_arn
  listener_arn    = module.load_balancer.listener_arn
  private_subnets = module.networking.private_subnet_id_list
}
