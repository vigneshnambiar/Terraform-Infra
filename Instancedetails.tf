variable "Instance_volume" {
  description = "Volume size"
  type        = number
  default     = 8
}

variable "Instance_volume_type" {
  description = "Instance_volume_type"
  type        = string
  default     = "gp2"
}