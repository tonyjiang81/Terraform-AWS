# Platform add-ons live outside the EKS control-plane stack so node/version
# churn in 40-eks does not force re-planning of every addon each time.
locals {
  addons = merge(
    var.enable_vpc_cni ? { "vpc-cni" = {} } : {},
    var.enable_kube_proxy ? { "kube-proxy" = {} } : {},
    var.enable_coredns ? { "coredns" = {} } : {},
    var.enable_ebs_csi ? { "aws-ebs-csi-driver" = {} } : {},
  )
}

resource "aws_eks_addon" "this" {
  for_each = local.addons

  cluster_name = var.cluster_name
  addon_name   = each.key

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}
