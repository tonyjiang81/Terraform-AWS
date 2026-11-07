variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "enable_vpc_cni" {
  type    = bool
  default = true
}

variable "enable_kube_proxy" {
  type    = bool
  default = true
}

variable "enable_coredns" {
  type    = bool
  default = true
}

variable "enable_ebs_csi" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
