variable "bucket" {
  type        = string
  description = "The S3 bucket name for storing backups"
}

variable "host" {
  type        = string
  description = "The host which will send backups to bucket"
}
