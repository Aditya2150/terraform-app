# Runbook — Flask App on AWS ECS Fargate

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Manage Different Environments](#2-manage-different-environments)
3. [How to Deploy the Application](#3-how-to-deploy-the-application)
4. [Verify Deployment](#4-verify-deployment)
5. [Rollback](#5-rollback)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. Prerequisites

### Tools / Credentials / Permissions

- Repository | https://github.com/Aditya2150/terraform-app.git
- Terraform | version >= 1.5.0
- AWS CLI configured
- IAM User with ReadOnlyAccess Policy


## 2. Manage Different Environments

Create a new .tfvars file for your environment in the envs folder.

Add the following variables for that environment:

### Infrastructure variables
- **env:** used for tagging the VPC
- **vpc_cidr:** VPC CIDR (10.0.0.0/16)
- **aws_region:** Region where thr Infra needs to be deployed
- **public_subnets:** Map of Public Subnets with CIDRs and AZs
- **private_subnets:** Map of Private Subnets with CIDRs and AZs

### Application variables
- **container_name:** Name of the Container
- **container_cpu:** Number of cpu units used by the task
- **container_memory:** Amount (in MiB) of memory used by the task
- **image_name:** Name of the application image in ECR
- **image_version:** Image version needs to be deployed
- **app_name:** Name of the Application
- **app_port:** Port used by the Application
- **app_protocol:** Protocol used by the App (HTTP/HTTPS)
- **logs_retention_days:** Log retention days in cloudwatch
- **logs_region:** Logs region
- **alb_listener_port:** Port exposed on the Application load balancer
- **alb_listener_protocol:** Protocol used by the ALB (HTTP/HTTPS)

## 3. How to Deploy the Application

- At First, Initalize the Terraform with **terraform init**
- Plan the infrastructure changes with **terraform plan** cmd with -var-file parameter
- Review the plan output. You should see resources being created only — no updates or destroys on a fresh account. If you see unexpected destroys, stop and investigate before proceeding.
- After verification run **terraform apply** with the -var-file parameter
```bash
terraform init

# Use different tfvars file for different environments
terraform plan -var-file=envs/dev.tfvars

# Apply
terraform apply -var-file=envs/dev.tfvars
```

## 4. Verify Deployment

- Check the service containers are up and running.
- Verify the Desired state and the Current state of the container matches
- Check for ALB Health and their targets should show them healthy
- Test the service health with the health endpoint.
- Finally verify the logs are flowing with no significant errors.

## 5. Rollback

### Service related Issues
- Redeploy the previous stable application image. 
- Update the **image_version** variable and do a terraform plan and apply.

### Infra related Issues
- Rollback to the previous commit in the git.
- And do a terraform plan and apply to rollback infra changes.

## 6. Troubleshooting

### Task stuck in pending or failing to start
- If the newly published version of the image not working.
- First step is to verify the cloudwatch logs.
- Most likely issues are 
  - Image_Not_Found in ECR, probably image not published to the ECR.
  - OOM_Killed due to resource crunch or pod taking excessive resources than allowed.
  - Exit code terminated, need to check cloudwatch logs to verify.

### ALB unhealthy
- Unhealthy ALB, means unhealthy targets.
- Check for /health path and the port on which the application is serving traffic.
- Check for security grp rule, 
  - alb sg must allow inbound on **alb_listener_port** and 
  - ecs sg must allow inbound on **app_port** from **alb_sg** security grp
- Check if application is listening on the correct port.


---

*Contact: @Aditya for infrastructure issues. Last updated: Apr 2026.*
