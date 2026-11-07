output "kms_key_arn" {
  value = module.kms.key_arn
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "eks_additional_security_group_id" {
  value = aws_security_group.eks_additional.id
}
