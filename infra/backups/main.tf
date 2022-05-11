module "device" {
  source = "./device"

  user       = var.host
  bucket_arn = aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket" "bucket" {

  bucket = var.bucket

}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "example-entire-bucket" {
  bucket = aws_s3_bucket.bucket.bucket
  name   = "EntireBucket"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    id     = "ExpireOldVersions"
    status = "Enabled"
    filter {
      prefix = var.host
    }
    noncurrent_version_expiration {
      noncurrent_days = 180
      newer_noncurrent_versions = 30
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
