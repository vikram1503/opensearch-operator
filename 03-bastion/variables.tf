variable "project_name" {
    default = "opensearch"
  
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    default = {
        Project = "opensearch"
        Environment = "dev"
        Terraform = "true"
    }
  
}