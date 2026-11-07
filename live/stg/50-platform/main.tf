module "addons" {
  source = "../../../modules/compute/eks-addons"

  cluster_name      = data.terraform_remote_state.eks.outputs.cluster_name
  cluster_version   = data.terraform_remote_state.eks.outputs.cluster_version
  oidc_provider_arn = data.terraform_remote_state.eks.outputs.oidc_provider_arn

  enable_vpc_cni    = true
  enable_kube_proxy = true
  enable_coredns    = true
  enable_ebs_csi    = true
}

# Example placeholder for future controllers (ALB, external-dns, cluster-autoscaler).
# Keep each controller in its own module/PR when it grows beyond ~100 resources.
