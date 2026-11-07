terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Bootstrap itself can use local state once, then migrate. After the bucket
  # exists, re-init with the S3 backend using the generated backend.hcl.
}
