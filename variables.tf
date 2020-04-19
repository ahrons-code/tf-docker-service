variable "service_name" {}
variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
}