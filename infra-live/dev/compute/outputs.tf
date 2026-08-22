# -----------------------------------------------------------------------------
# Golden AMI Pipeline
# -----------------------------------------------------------------------------

output "image_pipeline_arn" {
  description = "ARN of the development Golden AMI Image Builder pipeline."
  value       = module.ami_pipeline.image_pipeline_arn
}

# -----------------------------------------------------------------------------
# Golden AMI Recipe
# -----------------------------------------------------------------------------

output "image_recipe_arn" {
  description = "ARN of the development Golden AMI image recipe."
  value       = module.ami_pipeline.image_recipe_arn
}

# -----------------------------------------------------------------------------
# Image Builder Role
# -----------------------------------------------------------------------------

output "image_builder_role_arn" {
  description = "ARN of the IAM role used by the development Image Builder instances."
  value       = module.ami_pipeline.image_builder_role_arn
}

# -----------------------------------------------------------------------------
# Compute Security Group
# -----------------------------------------------------------------------------

output "compute_security_group_id" {
  description = "ID of the development compute security group."
  value       = module.compute_asg.compute_security_group_id
}
