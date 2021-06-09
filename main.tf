locals {
  envs = length(var.environment) > 0 ? jsonencode(var.environment) : jsonencode([])
}

provider "aws" {
  region = var.region
}

resource "aws_ecs_service" "service" {
  name = var.service_name
  cluster = data.aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count = 1
  force_new_deployment = true
}

resource "aws_ecs_task_definition" "task_definition" {
  family = var.service_name
  execution_role_arn    = "arn:aws:iam::245954399621:role/developer-admin"
  container_definitions = data.template_file.init.rendered
}

data "template_file" "init" {
  template = file("${path.module}/service.json")
  vars = {
    internal = var.internal_port
    external = var.external_port
    protocol = var.port_protocol
    log_stream = "ls_${var.service_name}"
    env = local.envs
    service_name = var.service_name
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name = "ls_${var.service_name}"
  log_group_name = data.aws_cloudwatch_log_group.log_group.name
}


data "aws_vpc" "private_1" {
  filter {
    name   = "tag:Name"
    values = ["private_1"]
  }
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "cl_prod"
}

data "aws_cloudwatch_log_group" "log_group" {
  name = "lg_prod"
}
