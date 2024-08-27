variable "subnet_depth" {
  description = "Number of public and private subnets to create in each availability zone"
  type        = number
  default     = 3
  validation {
    condition     = var.subnet_depth >= 1 && var.subnet_depth <= 3
    error_message = "Subnet depth must be between 1 and 3."
  }
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
