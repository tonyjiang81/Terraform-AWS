module "vpc" {
  source = "../../../modules/networking/vpc"

  name               = "${var.project}-${var.environment}"
  cidr               = var.vpc_cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}
