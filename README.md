# Terraform AWS — multi-env, multi-stack layout

Example AWS infrastructure repo following common Terraform best practices:

- **Split stacks by blast radius** — keep each stack reviewable (well under ~100 managed objects)
- **Isolate high-churn surfaces (EKS)** — plan/apply independently
- **Environments as directories**: `dev` / `qa` / `stg` / `prod` (not Terraform workspaces)
- **Reusable modules + opinionated live stacks**; stacks wire via **remote state**

Principles: [`docs/BEST-PRACTICES.md`](./docs/BEST-PRACTICES.md).

---

## Layout

```text
Terraform-AWS/
  modules/                      # reusable modules (thin wrappers)
    networking/vpc/
    security/kms/
    compute/eks/                # cluster + node groups only
    compute/eks-addons/         # add-ons in a separate module
    data/rds-postgres/
  live/
    bootstrap/                  # account-level: S3 state + DynamoDB lock (once)
    _templates/
    dev|qa|stg|prod/
      10-network/               # VPC
      20-security/              # KMS + baseline SG
      30-data/                  # RDS
      40-eks/                   # high churn — run alone
      50-platform/              # EKS add-ons (depends on 40-eks)
  scripts/tf.sh
  docs/BEST-PRACTICES.md
```

State key convention:

```text
s3://<bucket>/<project>/<env>/<stack>/terraform.tfstate
```

Example: `demo/dev/40-eks/terraform.tfstate`

---

## Apply order (per environment)

```text
bootstrap (account, once)
    → 10-network
        → 20-security
            → 30-data
            → 40-eks          ← iterate independently
                → 50-platform
```

Changing node groups or Kubernetes version: only `live/<env>/40-eks` — no need to touch VPC/RDS.

---

## Quick start

### 1) Bootstrap (once per AWS account)

```bash
cd live/bootstrap
cp terraform.tfvars.example terraform.tfvars   # set a globally unique state bucket name
terraform init
terraform apply
```

Note the `state_bucket` / `lock_table` outputs.

### 2) Configure one stack in an environment

```bash
cd live/dev/10-network
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
# edit bucket / CIDR / project name, etc.

../../../scripts/tf.sh init  live/dev/10-network
../../../scripts/tf.sh plan  live/dev/10-network
../../../scripts/tf.sh apply live/dev/10-network
```

Then the same pattern for: `20-security` → `30-data` / `40-eks` → `50-platform`.

### 3) Change only EKS

```bash
./scripts/tf.sh plan  live/stg/40-eks
./scripts/tf.sh apply live/stg/40-eks
# if add-ons changed:
./scripts/tf.sh plan  live/stg/50-platform
```

---

## Environment defaults (examples)

| | CIDR | NAT | Nodes | RDS | API endpoint |
|---|---|---|---|---|---|
| **dev** | `10.10.0.0/16` | single | `m6i.large`×2 | `db.t4g.medium` | public |
| **qa** | `10.20.0.0/16` | single | `m6i.large`×2 | `db.t4g.medium` | public |
| **stg** | `10.30.0.0/16` | per-AZ | `m6i.xlarge`×3 | `db.r6g.large` Multi-AZ | public |
| **prod** | `10.40.0.0/16` | per-AZ | `m6i.xlarge`×3 | `db.r6g.xlarge` Multi-AZ + deletion protection | **private only** |

---

## Practices this repo encodes

1. **One directory per env**, one state per stack  
2. **Separate high-churn (EKS) from low-churn (network/data)**  
3. **Pin module versions** (`terraform-aws-modules` with `~>` constraints)  
4. **No secrets in git** (`*.tfvars` ignored; commit `*.example` only)  
5. **Stronger prod defaults** (Multi-AZ, deletion protection, private API)  
6. **Reviewable plans** — avoid one root that builds the entire company  
7. **Next steps**: dedicated prod account, CI OIDC, Secrets Manager for RDS passwords  

---

## Validate (no AWS backend)

```bash
./scripts/tf.sh fmt
./scripts/tf.sh validate live/dev/10-network
./scripts/tf.sh validate live/dev/40-eks
```
