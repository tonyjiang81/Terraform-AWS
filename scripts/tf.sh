#!/usr/bin/env bash
# Helper to run terraform against a single live stack with remote backend.
# Usage:
#   ./scripts/tf.sh init  live/dev/40-eks
#   ./scripts/tf.sh plan  live/dev/40-eks
#   ./scripts/tf.sh apply live/dev/40-eks
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CMD="${1:?usage: $0 <init|plan|apply|destroy|fmt|validate> <stack-dir>}"
STACK_REL="${2:-}"

case "${CMD}" in
  fmt)
    terraform -chdir="${ROOT}" fmt -recursive
    exit 0
    ;;
esac

STACK_DIR="$(cd "${ROOT}/${STACK_REL}" && pwd)"
BACKEND_HCL="${BACKEND_HCL:-${STACK_DIR}/backend.hcl}"
TFVARS="${TFVARS:-${STACK_DIR}/terraform.tfvars}"

if [[ ! -f "${BACKEND_HCL}" ]]; then
  echo "[WARN] ${BACKEND_HCL} missing; copy backend.hcl.example -> backend.hcl first"
fi
if [[ ! -f "${TFVARS}" ]]; then
  echo "[WARN] ${TFVARS} missing; copy terraform.tfvars.example -> terraform.tfvars first"
fi

case "${CMD}" in
  init)
    terraform -chdir="${STACK_DIR}" init -backend-config="${BACKEND_HCL}" -reconfigure
    ;;
  plan)
    terraform -chdir="${STACK_DIR}" plan -var-file="${TFVARS}" -out="${STACK_DIR}/tfplan"
    ;;
  apply)
    if [[ -f "${STACK_DIR}/tfplan" ]]; then
      terraform -chdir="${STACK_DIR}" apply "${STACK_DIR}/tfplan"
    else
      terraform -chdir="${STACK_DIR}" apply -var-file="${TFVARS}"
    fi
    ;;
  destroy)
    terraform -chdir="${STACK_DIR}" destroy -var-file="${TFVARS}"
    ;;
  validate)
    terraform -chdir="${STACK_DIR}" init -backend=false >/dev/null
    terraform -chdir="${STACK_DIR}" validate
    ;;
  *)
    echo "unknown command: ${CMD}"
    exit 2
    ;;
esac
