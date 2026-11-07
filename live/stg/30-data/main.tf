module "postgres" {
  source = "../../../modules/data/rds-postgres"

  identifier             = "${var.project}-${var.environment}-pg"
  instance_class         = var.db_instance_class
  subnet_ids             = data.terraform_remote_state.network.outputs.private_subnet_ids
  vpc_security_group_ids = [data.terraform_remote_state.security.outputs.rds_security_group_id]
  kms_key_arn            = data.terraform_remote_state.security.outputs.kms_key_arn
  multi_az               = var.db_multi_az
  deletion_protection    = var.db_deletion_protection
  skip_final_snapshot    = !var.db_deletion_protection
}
