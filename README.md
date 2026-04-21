# Flask App — AWS ECS Fargate Deployment with Terraform

## Table of Contents
1. [What is being deployed](#1-what-is-being-deployed)
2. [AWS Architecture](#2-aws-architecture)
3. [How to use Terraform](#3-how-to-use-terraform)
4. [How to use GitHub Actions](#4-how-to-use-github-actions)
5. [Trade-offs made](#5-trade-offs-made)
6. [What would change for real production](#6-what-would-change-for-real-production)

---

## 1. What is being deployed

A containerised **Flask** (Python) web application running on **AWS ECS Fargate**.

The app is a stateless HTTP service packaged as a Docker image and stored in **Amazon ECR**. It is served through an **Application Load Balancer** over HTTPS and runs as a managed Fargate service — no EC2 instances to provision, patch, or manage.

---

## 2. AWS Architecture

```
             Internet
               │
               ▼ HTTP :80
┌─────────────────────────────────┐
│  Application Load Balancer      │  ← public subnets (2 AZs)
│  Listener → Target Group :4000  │
└─────────────────────────────────┘
               │
               ▼ HTTP :4000
┌─────────────────────────────────┐
│  ECS Fargate Service            │  ← private subnets (2 AZs)
│  2 tasks  |  512 vCPU  |  1 GB  │
│  Image pulled from ECR          │
└─────────────────────────────────┘
    │
    ├── Amazon ECR        (Docker image registry)
    ├── CloudWatch Logs   (/ecs/<app_name>, 14-day retention)
    └── NAT Gateways      (outbound internet for private subnets)
```

### Module breakdown

The infrastructure is split into three child modules, each with a single responsibility. Values flow between modules exclusively through outputs and variables — no module references another module's resources directly.

```
main.tf
 ├── module "networking"      ./modules/1-network
 ├── module "load_balancer"   ./modules/2-loadbalancers
 └── module "ecs"             ./modules/3-ecs
```

---

### `modules/1-network` — VPC & Networking

#### Resources:
- VPC
- Subnets (Public/Private)
- IGW
- Nat Gateways
- EIPs
- Security Groups (SGs)

**Why two AZs?** A single AZ failure would take the whole service down. Two AZs means the ALB and ECS tasks survive one AZ becoming unavailable.

**Why private subnets for ECS?** Fargate tasks are not directly reachable from the internet. All inbound traffic must enter through the ALB, which is the only public-facing component. This significantly reduces the attack surface.

**Why one NAT Gateway per AZ?** A single shared NAT Gateway is cheaper, but if its AZ goes down every private subnet loses outbound internet access. Per-AZ NAT Gateways also avoid cross-AZ data transfer costs on high-throughput workloads.

---

### `modules/2-loadbalancers` — ALB

#### Resources:
- Application Load Balancer (ALB)
- ALB Listeners
- Target Groups (TGs)

---

### `modules/3-ecs` — ECS Fargate

#### Resources:
- ECS Cluster
- Task Definition
- ECS Service
- ECR
- IAM Roles
- Cloudwatch Log Groups

---

## 3. How to use Terraform

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with credentials that can create the resources above

### Deploying an environment

All variable values live in per-environment `.tfvars` files under `envs/`.

```bash
# Initialise — downloads provider and resolves modules
terraform init

# Preview the plan scoped to a specific environment
terraform plan -var-file=envs/dev.tfvars

# Apply
terraform apply -var-file=envs/dev.tfvars
```

### Destroying an environment

```bash
terraform destroy -var-file=envs/dev.tfvars
```

> **Note:** The ECR repository must be empty before `terraform destroy` can delete it. Either delete images manually in the console or add `force_delete = true` to the `aws_ecr_repository` resource.

### Adding a new environment

1. Create a new `<env>.tfvars` file under `envs/`:

2. Run `terraform apply -var-file=envs/staging.tfvars`.

No Terraform module code needs to change — only the `.tfvars` file.

---

## 4. How to use GitHub Actions

The workflow at `.github/workflows/terraform.yml` runs on every **push to `main`** branch.


### Required setup

- No Additional steps required unless the workflow needs to be run on other branches except main and prod.
- If it is then the `on.push.branches` needs to be updated with the new branch name.
- And further more needs to add a case for `Select tfvars` step with the `<new env>.tfvars` file

---

## 5. Trade-offs made

1. **No remote state backend**: `terraform.tfstate` stored locally
2. **Single IAM execution role**: One role shared by all tasks
3. **No task role**: The container itself cannot call AWS APIs
4. **HTTP traffic on ALB**: Inbound Traffic is all unencrypted
5. **Plan-only CI**: GitHub Actions only runs `terraform plan`

---

## 6. What would change for real production

- **Security:**  Add TLS encryption, all traffic from outside to inside the cluster should be encrypted.
- **Scalability:** Add ECS Auto Scaling of pods based on cpu and memory usage.
- **Terraform:** Add Remote state backend via S3, and state locking via DynamoDB
- **Alarms:** Monitoring and Alarms based on Logs