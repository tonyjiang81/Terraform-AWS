module "kms" {
  source = "../../../modules/security/kms"

  name        = "${var.project}-${var.environment}"
  description = "CMK for ${var.project} ${var.environment}"
}

resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.environment}-rds"
  description = "Baseline SG for RDS (ingress filled by app stacks or security owners)"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-rds"
  }
}

resource "aws_security_group" "eks_additional" {
  name        = "${var.project}-${var.environment}-eks-additional"
  description = "Additional SG attached later by platform owners if needed"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-eks-additional"
  }
}
