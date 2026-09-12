output "plan_role_arn" {
  value = aws_iam_role.tfc_plan.arn
}

output "apply_role_arn" {
  value = aws_iam_role.tfc_apply.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.tfc.arn
}