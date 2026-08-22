# -----------------------------------------------------------------------------
# PostgreSQL
# -----------------------------------------------------------------------------

variable "engine_version" {
  description = "PostgreSQL engine version for the development RDS instance."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class for the development database."
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GiB for the development database."
  type        = number
}

variable "database_name" {
  description = "Initial PostgreSQL database name."
  type        = string
}

variable "master_username" {
  description = "Master username for the PostgreSQL database."
  type        = string
}

# -----------------------------------------------------------------------------
# Backup
# -----------------------------------------------------------------------------

variable "backup_retention_period" {
  description = "Number of days automated backups are retained."
  type        = number
}
