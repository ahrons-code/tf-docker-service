variable "service_name" {}
variable "task_definition" {}
variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
}