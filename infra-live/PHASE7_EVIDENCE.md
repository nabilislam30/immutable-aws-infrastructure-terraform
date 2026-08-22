# Phase 7 CI/CD Completion Evidence

## Scope

Phase 7 implements the delivery and operational control pattern for the Terraform components currently deployed from `infra-live`.

## Completed CI/CD Paths

| Component | PR Plan | Reviewed Saved Plan Apply | Status |
| --- | --- | --- | --- |
| Dev VPC | ✅ | ✅ | Complete |
| Dev Database | ✅ | ✅ | Complete |
| Dev Compute | ✅ | ✅ | Complete |
| Staging VPC | ✅ | ✅ | Complete |
| Production VPC | ✅ | ✅ with production approval | Complete |

## Pull Request Validation

Terraform pull request workflows perform the following checks before merge:

- Terraform format validation
- Terraform validation
- TFLint
- Trivy IaC scanning
- Terraform plan
- Plan publication to the pull request
- Upload of the saved Terraform plan as an immutable workflow artifact

The PR workflows check out the exact pull request head commit so the reviewed plan is tied to the commit being reviewed.

## Immutable Apply Pattern

Apply workflows do not create a replacement plan after merge.

They:

1. identify the reviewed pull request commit,
2. locate the successful PR plan workflow for that exact commit,
3. download the matching saved Terraform plan artifact,
4. initialise Terraform,
5. apply the reviewed `tfplan` directly.

This provides evidence that the deployed change is the same change that was reviewed during the pull request.

## AWS Authentication

GitHub Actions uses AWS OIDC authentication rather than long-lived AWS access keys.

Deployment roles:

- `tf-deploy-dev`
- `tf-deploy-staging`
- `tf-deploy-prod`

Production pull-request planning uses the separate `tf-plan-prod` identity, keeping production planning separate from the production deployment role.

## Backend Permissions

Environment deployment identities have access to their own Terraform state prefixes and the shared Terraform state lock table required by the CI/CD workflows.

Production and staging backend permissions were added through the versioned `iam-roles` module release `v1.8.13` and deployed through `infra-live/global`.

## Staging Verification

The staging VPC PR plan refreshed the existing staging VPC state and returned no changes.

The merged workflow then successfully downloaded and applied the reviewed saved Terraform plan.

## Production Verification

The production VPC PR plan refreshed the existing production VPC state and returned no changes.

The production deployment flow required the GitHub Environment `prod` approval checkpoint before the apply job could continue.

The production approval was recorded in GitHub Actions and the subsequent reviewed-plan apply completed successfully.

For this personal portfolio repository, the repository owner was used as the required environment reviewer. This demonstrates the GitHub Environment approval mechanism, although it is not equivalent to independent four-eyes approval.

## Drift Detection

The `Terraform Drift Detection` workflow runs nightly and supports manual execution.

Current drift matrix:

- `dev-vpc`
- `dev-database`
- `dev-compute`
- `staging-vpc`
- `prod-vpc`

The workflow runs `terraform plan -detailed-exitcode` so that:

- exit code `0` means no drift,
- exit code `1` means a Terraform error,
- exit code `2` means drift is detected.

A drift plan is uploaded as an artifact when drift is detected.

A manual verification run was completed successfully across all five matrix jobs with no drift reported.

## Phase 7 Outcome

Phase 7 is complete for the infrastructure currently deployed in the repository.

The implemented control pattern now includes:

- pull-request validation,
- exact-commit Terraform planning,
- plan review in GitHub,
- immutable saved-plan deployment,
- GitHub OIDC authentication,
- environment-specific IAM roles,
- staging deployment automation,
- production approval protection,
- production deployment automation,
- nightly Terraform drift detection.

## Remaining Future Extensions

The following are future extensions rather than Phase 7 blockers:

- staging compute and database workloads,
- production compute and database workloads,
- independent second-person production approval,
- AWS IAM Identity Center integration when the required AWS organisation prerequisites are available.
