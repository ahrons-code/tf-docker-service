resource "aws_ecs_service" "service" {
  name            = "${var.service_name}"
  cluster         = "${data.aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = 1

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [eu-west-1c]"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "${var.service_name}"
  container_definitions = "${data.template_file.init.rendered}"
}

data "template_file" "init" {
  template = "${file("service.json")}"
  vars = {
    docker_ports = "${join(", ", ${var.docker_ports})}"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "ls_${var.service_name}"
  log_group_name = "${data.aws_cloudwatch_log_group.log_group.name}"
}

data "aws_ecs_cluster" "cluster" {
  cluster_name = "cl_prod"
}

data "aws_cloudwatch_log_group" "log_group" {
  name = "lg_prod"
}
