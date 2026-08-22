# 🌍 infra-live

> Live Terraform configuration for immutable AWS infrastructure.

`infra-live` contains the environment-specific Terraform configuration used to deploy AWS infrastructure. Reusable infrastructure code is maintained in the companion `infra-modules` repository and consumed here through version-pinned module releases.

---

# 📖 Overview

This repository represents the live deployment layer of the project.

The implementation is built around:

- Immutable Infrastructure
- Infrastructure as Code with Terraform
- Versioned reusable modules
- Remote Terraform state and locking
- GitHub Actions CI/CD
- GitHub OIDC authentication to AWS
- Least-privilege IAM deployment roles
- Pull request plan review
- Immutable saved Terraform plans
- Production approval protection
- Automated drift detection

---

# 🏗 Repository Structure

```text
infra-live/
│
├── global/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── .trivyignore
│
├── dev/
│   ├── vpc/
│   ├── compute/
│   └── database/
│
├── staging/
│   └── vpc/
│
├── prod/
│   └── vpc/
│
├── .github/
│   └── workflows/
│
├── .gitignore
├── .pre-commit-config.yaml
└── README.md
```

---

# 🌎 Deployment Status

| Scope | Current deployment | Status |
| --- | --- | --- |
| Global | Security baseline, guardrails, IAM roles, monitoring and cost controls | ✅ Complete |
| Development | VPC, compute, golden AMI pipeline and PostgreSQL database | ✅ Complete |
| Staging | VPC | ✅ Complete |
| Production | VPC | ✅ Complete |
| CI/CD | PR plans, reviewed saved-plan applies, OIDC and production approval | ✅ Complete |
| Drift Detection | Nightly and manual checks across deployed components | ✅ Complete |

Staging and production currently contain VPC deployments only. Additional application workloads can be added later without changing the established pipeline pattern.

---

# 🔐 Global Infrastructure

The global deployment provides shared account-level governance and security services, including:

- AWS CloudTrail
- AWS Config and managed rules
- Amazon GuardDuty
- AWS Security Hub
- IAM Access Analyzer
- Default EBS encryption
- S3 account public access protection
- CloudWatch logging
- Customer-managed KMS encryption
- IAM deployment roles and permission boundaries
- Terraform backend access controls
- Monitoring and cost controls

---

# 🧩 Terraform Module Architecture

Reusable infrastructure is maintained separately in `infra-modules` and consumed using immutable Git tags.

```text
infra-live
    │
    ▼
version-pinned infra-modules releases
    │
    ▼
Terraform
    │
    ▼
AWS
```

Example:

```hcl
module "iam_roles" {
  source = "git::https://github.com/nabilislam30/infra-modules.git//iam-roles?ref=v1.8.13"
}
```

Pinning module versions makes deployments reproducible and prevents unreviewed module changes from reaching live environments.

---

# ☁ AWS Deployment Target

| Setting | Value |
| --- | --- |
| AWS Account | `442847318797` |
| Primary Region | `eu-west-2` |
| Infrastructure Tool | Terraform |
| Module Repository | `infra-modules` |
| CI/CD | GitHub Actions |
| AWS Authentication | GitHub OIDC |

---

# 💾 Remote State

Terraform state is stored remotely in S3 and protected with state locking.

```text
S3 bucket:
fimatix-devops-starter-tfstate-442847318797

DynamoDB lock table:
terraform-state-locks
```

State is separated by environment and component, for example:

```text
global/terraform.tfstate
dev/vpc/terraform.tfstate
dev/database/terraform.tfstate
dev/compute/terraform.tfstate
staging/vpc/terraform.tfstate
prod/vpc/terraform.tfstate
```

---

# ⚙ CI/CD Workflow

Infrastructure changes follow a reviewed and immutable deployment path.

```text
Feature branch
    │
    ▼
Pull Request
    │
    ├── terraform fmt
    ├── terraform validate
    ├── TFLint
    ├── Trivy IaC scan
    └── Terraform plan
    │
    ▼
Plan published to PR + saved as artifact
    │
    ▼
Review and merge
    │
    ▼
Download exact reviewed plan artifact
    │
    ▼
Terraform apply saved plan
```

The apply workflows do not generate a new plan. They download and apply the exact plan produced during pull request review.

For production, a GitHub Environment named `prod` provides an explicit approval checkpoint before the reviewed production plan is applied.

---

# 🔑 GitHub OIDC and IAM

GitHub Actions authenticates to AWS through OIDC rather than long-lived AWS access keys.

Environment deployment roles include:

```text
tf-deploy-dev
tf-deploy-staging
tf-deploy-prod
```

Production pull requests use a separate read-oriented planning identity:

```text
tf-plan-prod
```

This keeps production planning separate from the production deployment role and preserves the main-branch trust restriction for production writes.

---

# 🔍 Drift Detection

Terraform drift detection runs every night and can also be started manually from GitHub Actions.

The matrix currently checks:

```text
dev-vpc
dev-database
dev-compute
staging-vpc
prod-vpc
```

Terraform `-detailed-exitcode` is used so the workflow can distinguish between:

- `0` — no drift
- `1` — Terraform error
- `2` — infrastructure drift detected

A detected drift plan is retained as a GitHub Actions artifact for investigation.

---

# 🧪 Validation and Security Gates

The CI workflows use:

- Terraform Format
- Terraform Validate
- TFLint
- Trivy IaC scanning
- Terraform plan review
- Immutable plan artifacts
- GitHub OIDC
- Environment-specific AWS IAM roles
- Production deployment approval
- Scheduled drift detection

Trivy is used as the repository-standard IaC security scanner.

---

# 🚀 Deployment

Normal infrastructure changes should be deployed through GitHub Actions rather than by manually applying from a workstation.

For local validation only:

```bash
terraform init
terraform validate
terraform plan
```

Manual live mutation should be avoided so Terraform and version control remain the authoritative write path.

---

# ✅ Phase 7 Completion

Phase 7 established the full CI/CD and operational control pattern for the components currently deployed in this repository.

Completed outcomes include:

- Dev VPC PR plan and reviewed-plan apply
- Dev database PR plan and reviewed-plan apply
- Dev compute PR plan and reviewed-plan apply
- Staging VPC PR plan and reviewed-plan apply
- Production VPC PR plan using `tf-plan-prod`
- Production environment approval before apply
- Exact PR-head checkout for reviewed plans
- Immutable saved Terraform plan artifacts
- GitHub OIDC authentication
- Environment-specific backend permissions
- Nightly multi-component Terraform drift detection
- Successful manual drift verification across all five deployed components

See [`PHASE7_EVIDENCE.md`](PHASE7_EVIDENCE.md) for the completion evidence summary.

---

# 🗺 Roadmap

## Completed

- ✅ Remote Terraform state and locking
- ✅ Global security baseline
- ✅ Account guardrails
- ✅ Monitoring and cost controls
- ✅ Reusable VPC module deployments
- ✅ Golden AMI pipeline
- ✅ Development Auto Scaling and ALB compute
- ✅ Development PostgreSQL RDS
- ✅ GitHub OIDC deployment roles
- ✅ PR-based Terraform validation and planning
- ✅ Immutable reviewed-plan deployment
- ✅ Production approval protection
- ✅ Automated Terraform drift detection

## Future Extensions

- Staging compute and database workloads
- Production compute and database workloads
- Additional application delivery pipelines
- AWS IAM Identity Center integration when organisation prerequisites are available

---

# 📂 Related Repository

Reusable Terraform modules are maintained in the companion repository:

```text
infra-modules
```

The live repository consumes versioned releases from that repository rather than duplicating reusable resource definitions.

---

# 🤝 Contributing

1. Create a feature branch.
2. Implement the Terraform change.
3. Run local validation where appropriate.
4. Open a pull request.
5. Review the generated Terraform plan.
6. Merge only after the plan is understood and approved.
7. Allow the apply workflow to deploy the reviewed saved plan.

---

# 📜 License

This repository is provided for learning, portfolio, and infrastructure engineering purposes.
