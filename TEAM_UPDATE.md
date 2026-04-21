# Team Update — Flask App Infrastructure Deployment
---

## Slack Message

---

Hi @Team, 
We will be rolling out a containerized service on ECS Fargate within the dev environment, which will be positioned behind an HTTP Application Load Balancer and deployed in a newly created VPC on AWS.
### Key Changes: 
- New VPC with a Public & Private subnets across 2 Availability zones.
- HTTP Load Balancer(port: 80) as an entry-point
- Flask app running as 2 Fargate tasks in private subnet (port: 4000)
- Cloudwatch Logs available at `/ecs/dev-app` (14 Days retention)
- GitHub Actions run `Terraform plan` on code push to `main` branch 

### Impact
No Impact to customers, newly build application and the environment.

### Timeline
This change will be applied on 24th April 10:00 AM IST

### Links
- **GitHub Repo:** github.com/Aditya2150/terraform-app
- **Architecture & Runbook:** README.md
- Cloudwatch Logs: `/ecs/dev-app`

### Risks/Concerns
- Low Risk change being a development environment.
- Static Container count, can degrade the application during traffic spikes
- No TLS encryption, on the service yet.
- No Monitoring or Alarms if the service crashes.

### Contact
**Infrastructure Owner:** @Aditya Jain

**Flask app Development Owner:** @developer
