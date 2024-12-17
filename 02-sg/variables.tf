variable "project_name" {
    default = "OpenSearch"
  
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    default = {
        Project = "OpenSearch"
        Environment = "dev"
        Terraform = "true"
    }
  
}


