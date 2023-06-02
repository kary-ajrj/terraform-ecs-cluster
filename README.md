# terraform-ecs-cluster
- This repo uses Terraform as IaC to deploy on AWS.
- It is utilising ECS cluster to deploy a service that shows "Hello World!" text on 3000 port.
- This is a mono-repo but the modules directory can be pulled out as another repo if the teams are multiple different teams.
- We are using AWS S3 as remote backend.
- It has Github Action pipelines that deploys QA and Production infra/service (manually).
- The modules can be parameterised further if needed.
Note: ECR was created manually.