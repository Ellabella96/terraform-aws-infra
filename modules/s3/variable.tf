variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "bucket_purpose" {
  description = "Purpose of the bucket (e.g., 'app-data', 'logs', 'backups')"
  type        = string
  default     = "app-data"
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block public access to the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Enable lifecycle management for the S3 bucket"
  type        = bool
  default     = false
}

variable "transition_to_ia_days" {
  description = "Number of days before transitioning objects to IA storage class"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Number of days before transitioning objects to Glacier storage class"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Number of days before objects expire"
  type        = number
  default     = 365
}
