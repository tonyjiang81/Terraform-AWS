# EKS changes often (version bumps, node groups). Keep add-ons in a separate stack
# so day-2 cluster upgrades do not rewrite unrelated state.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access       = var.endpoint_public_access
  cluster_endpoint_private_access      = var.endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  enable_irsa = var.enable_irsa

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    for name, ng in var.managed_node_groups : name => {
      instance_types = ng.instance_types
      min_size       = ng.min_size
      max_size       = ng.max_size
      desired_size   = ng.desired_size
      capacity_type  = ng.capacity_type
      disk_size      = ng.disk_size

      labels = {
        "workload-type" = name
      }
    }
  }

  tags = var.tags
}
