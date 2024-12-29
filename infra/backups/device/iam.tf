
resource "aws_iam_user" "backup_user" {
  name = var.user
  path = "/"
}

resource "aws_iam_access_key" "backup_user" {
  user = aws_iam_user.backup_user.name
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]
    resources = [
      "${var.bucket_arn}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.bucket_arn}/${var.user}",
      "${var.bucket_arn}/${var.user}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name = "AllowS3Access-${aws_iam_user.backup_user.name}"
  path = "/"

  policy = data.aws_iam_policy_document.s3_access.json
}

resource "aws_iam_user_policy_attachment" "backup_user_s3_access" {
  user       = aws_iam_user.backup_user.name
  policy_arn = aws_iam_policy.s3_access.arn
}

