variable "name" {
  type        = string
  description = "Name prefix for VPC resources."
}

variable "cidr" {
  type        = string
  description = "VPC IPv4 CIDR."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for subnets."
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDRs (one per AZ)."
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDRs (one per AZ)."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateways for private subnets."
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT gateway (cheaper for non-prod)."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}
