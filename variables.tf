variable "service_name" {}
variable "internal_port" {}
variable "external_port" {}
variable "port_protocol" {}

variable "region" {
  default = "eu-west-1"
}

variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
}