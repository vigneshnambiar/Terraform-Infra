variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "Region"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t3.micro"
}