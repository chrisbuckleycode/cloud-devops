variable "subnet_depth" {
  description = "Number of web, app and db subnets to create in each availability zone"
  type        = number
  default     = 2
  validation {
    condition     = var.subnet_depth >= 1 && var.subnet_depth <= 3
    error_message = "Subnet depth must be between 1 and 3."
  }
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "image_id" {
  default = "ami-066784287e358dad1"
}
