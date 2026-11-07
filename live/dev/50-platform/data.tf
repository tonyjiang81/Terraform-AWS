data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "${var.project}/${var.environment}/40-eks/terraform.tfstate"
    region = var.state_region
  }
}
