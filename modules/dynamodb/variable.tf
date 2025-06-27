# modules/dynamodb/variables.tf
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "table_purpose" {
  description = "Purpose of the table (e.g., 'users', 'sessions', 'orders')"
  type        = string
  default     = "app-data"
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be either PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "hash_key" {
  description = "The attribute to use as the hash (partition) key"
  type        = string
}

variable "range_key" {
  description = "The attribute to use as the range (sort) key"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of nested attribute definitions"
  type = list(object({
    name = string
    type = string
  }))
}

variable "read_capacity" {
  description = "Number of read units for this table (only used with PROVISIONED billing_mode)"
  type        = number
  default     = 20
}

variable "write_capacity" {
  description = "Number of write units for this table (only used with PROVISIONED billing_mode)"
  type        = number
  default     = 20
}

variable "global_secondary_indexes" {
  description = "List of global secondary indexes"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "List of local secondary indexes"
  type = list(object({
    name            = string
    range_key       = string
    projection_type = string
  }))
  default = []
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "ttl_attribute" {
  description = "The name of the table attribute to store the TTL timestamp in"
  type        = string
  default     = ""
}