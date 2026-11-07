# Terraform AWS — 多环境、多栈布局

按 Terraform 常见最佳实践拆好的示例仓库：

- **infra 按 blast radius 分栈**，单栈控制在可审阅规模（远低于「一百个组件」量级）
- **高变更面（EKS）独立栈**，可单独 `plan/apply`
- **环境用目录隔离**：`dev` / `qa` / `stg` / `prod`（不用 workspace 区分环境）
- **模块可复用，live 可落地**；栈之间用 **远程 state** 传递输出

详细原则见 [`docs/BEST-PRACTICES.md`](./docs/BEST-PRACTICES.md)。英文主文档见 [`README.md`](./README.md)。

---

## 目录结构

```text
Terraform-AWS/
  modules/                      # 可复用模块（薄封装）
    networking/vpc/
    security/kms/
    compute/eks/                # 仅 cluster + node groups
    compute/eks-addons/         # 插件单独模块
    data/rds-postgres/
  live/
    bootstrap/                  # 账号级：S3 state + DynamoDB lock（跑一次）
    _templates/
    dev|qa|stg|prod/
      10-network/               # VPC
      20-security/              # KMS + baseline SG
      30-data/                  # RDS
      40-eks/                   # 高频变更，单独运行
      50-platform/              # EKS add-ons（依赖 40-eks）
  scripts/tf.sh
  docs/BEST-PRACTICES.md
```

State key 约定：

```text
s3://<bucket>/<project>/<env>/<stack>/terraform.tfstate
```

示例：`demo/dev/40-eks/terraform.tfstate`

---

## 依赖顺序（每个环境）

```text
bootstrap (account, once)
    → 10-network
        → 20-security
            → 30-data
            → 40-eks          ← 可单独迭代
                → 50-platform
```

只改节点组 / K8s 版本时：进入 `live/<env>/40-eks` 即可，不必碰 VPC/RDS。

---

## 快速开始

### 1) Bootstrap（每个 AWS 账号一次）

```bash
cd live/bootstrap
cp terraform.tfvars.example terraform.tfvars   # 改唯一的 state bucket 名
terraform init
terraform apply
```

记下输出的 `state_bucket` / `lock_table`。

### 2) 配置某个环境的一个栈

```bash
cd live/dev/10-network
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
# 编辑 bucket / CIDR / 项目名等

../../../scripts/tf.sh init  live/dev/10-network
../../../scripts/tf.sh plan  live/dev/10-network
../../../scripts/tf.sh apply live/dev/10-network
```

其余栈同样：`20-security` → `30-data` / `40-eks` → `50-platform`。

### 3) 只动 EKS

```bash
./scripts/tf.sh plan  live/stg/40-eks
./scripts/tf.sh apply live/stg/40-eks
# add-ons 有变化再跑：
./scripts/tf.sh plan  live/stg/50-platform
```

---

## 环境差异（示例默认值）

| | CIDR | NAT | Node | RDS | API 公网 |
|---|---|---|---|---|---|
| **dev** | `10.10.0.0/16` | single | `m6i.large`×2 | `db.t4g.medium` | yes |
| **qa** | `10.20.0.0/16` | single | `m6i.large`×2 | `db.t4g.medium` | yes |
| **stg** | `10.30.0.0/16` | per-AZ | `m6i.xlarge`×3 | `db.r6g.large` Multi-AZ | yes |
| **prod** | `10.40.0.0/16` | per-AZ | `m6i.xlarge`×3 | `db.r6g.xlarge` Multi-AZ + deletion protection | **private only** |

---

## 本仓库刻意遵守的实践

1. **一环境一目录**，一栈一 state  
2. **高频变更栈（EKS）与低频栈（网络/数据）分离**  
3. **模块版本钉住**（`terraform-aws-modules` ~> 约束）  
4. **密钥不进 git**（`*.tfvars` ignore，只提交 `*.example`）  
5. **prod 更强默认**（Multi-AZ、deletion protection、私有 API）  
6. **计划可审阅**：避免「一个 root 建完整个公司」  
7. **推荐后续**：prod 独立账号、CI OIDC、Secrets Manager 接管 RDS 密码

---

## 校验（不连 AWS backend）

```bash
./scripts/tf.sh fmt
./scripts/tf.sh validate live/dev/10-network
./scripts/tf.sh validate live/dev/40-eks
```
