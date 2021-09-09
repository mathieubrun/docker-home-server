module "device" {
  source = "./device"

  user       = var.host
  bucket_arn = module.backups_bucket.s3_bucket_arn
}

module "backups_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id      = "ExpireNonCurrentVersions"
      enabled = true
      prefix  = "${var.host}/nextcloud/files/"
      noncurrent_version_expiration = {
        days = 180
      }
    },
    {
      id      = "ExpireNextcloudBackups"
      enabled = true
      prefix  = "${var.host}/nextcloud/database/"

      expiration = {
        days = 30
      }
      noncurrent_version_expiration = {
        days = 1
      }
    }
  ]
}

