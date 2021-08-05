output "backup_user_secret" {
  value = aws_iam_access_key.backup_user.secret
  sensitive = true
}

output "backup_user_id" {
  value = aws_iam_access_key.backup_user.id
}

output "backup_user" {
  value = aws_iam_access_key.backup_user.user
}