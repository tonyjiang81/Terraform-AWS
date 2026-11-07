# Intentionally ONLY cluster + managed node groups.
# Add-ons, controllers, and app IRSA live in 50-platform.
module "eks" {
  source = "../../../modules/compute/eks"

  cluster_name            = "${var.project}-${var.environment}"
  cluster_version         = var.cluster_version
  vpc_id                  = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids              = data.terraform_remote_state.network.outputs.private_subnet_ids
  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = true

  managed_node_groups = {
    general = {
      instance_types = var.node_instance_types
      min_size       = 1
      max_size       = max(var.node_desired_size * 2, 3)
      desired_size   = var.node_desired_size
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
    }
  }
}
