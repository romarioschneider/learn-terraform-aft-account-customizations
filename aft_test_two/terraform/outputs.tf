output "AWSReadOnlyAccess_users" {
  value = [for assignment in aws_ssoadmin_account_assignment.AWSReadOnlyAccess_users: assignment.id]
}

output "AWSReadOnlyAccess_groups" {
  value = [for assignment in aws_ssoadmin_account_assignment.AWSReadOnlyAccess_groups: assignment.id]
}