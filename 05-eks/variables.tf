variable "common_tags" {
  default = {
    Project     = "OpenSearch"
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "sg_tags" {
  default = {}
}

variable "project_name" {
  default = "OpenSearch"
}
variable "environment" {
  default = "dev"
}

variable "cluster_service_ipv4_cidr" {
  default = "10.100.0.0/16"
}