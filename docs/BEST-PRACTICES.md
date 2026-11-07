# Terraform AWS practices used in this repo

## 1. Split by blast radius, not by resource type alone

| Stack | Why separate |
|---|---|
| `bootstrap` | Rarely changes; owns state backend for the account |
| `10-network` | VPC is foundational; churn is low |
| `20-security` | KMS / baseline SGs; shared by data & compute |
| `30-data` | Databases change on a different cadence than nodes |
| `40-eks` | **Highest churn** (version, node groups) — run alone |
| `50-platform` | Add-ons / controllers; depends on EKS outputs |

Guideline: keep each stack well under ~100 managed objects so plans stay reviewable.

## 2. Environments are directories, not workspaces

`live/dev`, `live/qa`, `live/stg`, `live/prod` each have their own state keys:

```text
s3://<bucket>/<project>/<env>/<stack>/terraform.tfstate
```

Workspaces are avoided for env isolation: wrong `terraform workspace select` is a common prod incident.

## 3. Compose with remote state, not mega-modules

Downstream stacks read upstream outputs via `terraform_remote_state` (network → security → data/eks → platform).  
Do not `terraform apply` a single root that creates VPC+EKS+RDS+addons together.

## 4. Modules are reusable; live stacks are opinionated

- `modules/**` = building blocks (thin wrappers around community modules where useful)
- `live/**` = wired for one env/stack with concrete CIDRs and sizes

Pin module and provider versions.

## 5. Separate “easy to change” from “dangerous to change”

EKS control plane + node groups live in `40-eks`.  
Core add-ons live in `50-platform`.  
Day-2 node scaling or version bumps should not rewrite RDS or VPC state.

## 6. Backend, locking, encryption

- S3 state + DynamoDB lock (`live/bootstrap`)
- Bucket versioning + SSE + public access block
- No plaintext secrets in git (`*.tfvars` ignored; only `*.example` committed)

## 7. Promote by code, not by clicking

Same module versions across envs; only `terraform.tfvars` differ (CIDR, size, HA flags).  
Promotion path: `dev → qa → stg → prod` with plan review; prod apply requires approval.

## 8. Account strategy (recommended)

| Env | Recommendation |
|---|---|
| dev/qa | Shared non-prod account OK for small teams |
| stg | Prefer dedicated account |
| prod | Dedicated account + tighter IAM / SCPs |

This repo is single-account capable; multi-account is an IAM/bootstrap concern, not a module rewrite.

## 9. CI/CD

- PR: `terraform fmt -check`, `validate`, `plan` for touched stacks only
- Merge to main: auto-apply `dev`/`qa` optional; `stg`/`prod` manual approval
- Never store long-lived AK/SK in CI; prefer OIDC to AWS

## 10. Tagging

Every provider sets `default_tags`: `Environment`, `Stack`, `ManagedBy`, plus project tags from tfvars.
