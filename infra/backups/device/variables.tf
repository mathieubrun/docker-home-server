variable "user" {
  type = string
  description = "The IAM user name for backups"
}

variable "bucket_arn" {
  type = string
  description = "The S3 bucket ARN for storing backups"
}