# terraform-ecs-cluster
- This repo uses Terraform as IaC to deploy on AWS.
- It is utilising ECS cluster to deploy a service that shows "Hello World!" text on 3000 port.
- This is a mono-repo but the modules directory can be pulled out into another repo.
- AWS S3 is being used as remote backend.
- Terraform workspaces are being leveraged.
- It has Github Action pipelines that deploys QA and Production infra/service (manually). The pipelines can be refactored to have environment as a parameter.
- The modules can be parameterised further if needed.
- Note: ECR and S3 were created manually.