# service
This is where we will create service level components like ecs service, task etc and register them to the ECS cluster that we created in the shared components.

# Usage
	terraform apply -var-file="config/dev/terraform.tfvars"
	terraform destroy -var-file="config/dev/terraform.tfvars"
	terraform apply -var-file="config/stage/terraform.tfvars"
	terraform destroy -var-file="config/stage/terraform.tfvars"
	terraform apply -var-file="config/prod/terraform.tfvars"
	terraform destroy -var-file="config/prod/terraform.tfvars"		