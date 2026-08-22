# -----------------------------------------------------------------------------
# Dev SSH Learning Mode
# -----------------------------------------------------------------------------
variable "key_name" {
  description = "EC2 key pair name used for Phase 6b development SSH learning mode."
  type        = string
}

variable "my_ip" {
  description = "Public IPv4 address allowed to SSH to development compute instances."
  type        = string
}
