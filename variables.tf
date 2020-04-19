variable "service_name" {}
variable "internal_port" {}
variable "external_port" {}
variable "port_protocol" {}
variable "environment" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
}