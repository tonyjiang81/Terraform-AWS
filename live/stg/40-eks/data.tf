data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.state_bucket
    key    = "${var.project}/${var.environment}/10-network/terraform.tfstate"
    region = var.state_region
  }
}
