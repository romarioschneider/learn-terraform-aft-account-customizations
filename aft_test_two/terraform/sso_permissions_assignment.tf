data "aws_ssoadmin_instances" "sso_instance" {
  provider = aws.aws_sso
}

# Permission sets
data "aws_ssoadmin_permission_set" "AWSReadOnlyAccess" {
  provider     = aws.aws_sso
  instance_arn = data.aws_ssoadmin_instances.sso_instance.arns[0]
  name         = "AWSReadOnlyAccess"

}

# AWSReadOnlyAccess ###########################################################################################
# Users
data "aws_identitystore_user" "sso_identitystore_user_AWSReadOnlyAccess" {
  provider          = aws.aws_sso
  for_each          = { for user, name in local.AWSReadOnlyAccess_users : user => name }
  identity_store_id = data.aws_ssoadmin_instances.sso_instance.identity_store_ids[0]
  filter {
    attribute_path  = "UserName"
    attribute_value = each.value.user
  }
}

resource "aws_ssoadmin_account_assignment" "AWSReadOnlyAccess_users" {
  provider           = aws.aws_sso
  for_each           = { for user, name in local.AWSReadOnlyAccess_users : user => name }
  instance_arn       = data.aws_ssoadmin_instances.sso_instance.arns[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.AWSReadOnlyAccess.arn
  principal_id       = data.aws_identitystore_user.sso_identitystore_user_AWSReadOnlyAccess[each.key].user_id
  principal_type     = "USER"
  target_id          = data.aws_caller_identity.current.id
  target_type        = "AWS_ACCOUNT"
}

# Groups
data "aws_identitystore_group" "sso_identitystore_group_AWSReadOnlyAccess" {
  provider          = aws.aws_sso
  for_each          = { for group, name in local.AWSReadOnlyAccess_groups : group => name }
  identity_store_id = data.aws_ssoadmin_instances.sso_instance.identity_store_ids[0]
  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.value.group
  }
}

resource "aws_ssoadmin_account_assignment" "AWSReadOnlyAccess_groups" {
  provider           = aws.aws_sso
  for_each           = { for group, name in local.AWSReadOnlyAccess_groups : group => name }
  instance_arn       = data.aws_ssoadmin_instances.sso_instance.arns[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.AWSReadOnlyAccess.arn
  principal_id       = data.aws_identitystore_group.sso_identitystore_group_AWSReadOnlyAccess[each.key].group_id
  principal_type     = "GROUP"
  target_id          = data.aws_caller_identity.current.id
  target_type        = "AWS_ACCOUNT"
}
#################################################################################################################

locals {
  AWSReadOnlyAccess_groups = flatten([
    for group in try(var.permissions_sets_assignments["AWSReadOnlyAccess"]["groups"], []) : { group = group }
  ])
  AWSReadOnlyAccess_users = flatten([
    for group in try(var.permissions_sets_assignments["AWSReadOnlyAccess"]["users"], []) : { user = group }
  ])
}