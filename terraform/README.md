# Terraform

```
terraform/
├── modules/app/        All the AWS resources, written ONCE
│                       (server, firewall, IP, S3 bucket, roles)
└── environments/
    ├── dev/            Uses modules/app with environment = "dev"
    ├── qa/             Uses modules/app with environment = "qa"
    └── prod/           Uses modules/app with environment = "prod"
```

- **Change a resource for all environments** → edit `modules/app/`
- **Change a setting for one environment** (e.g. server size) → edit `environments/<env>/main.tf`
- Each environment has its **own state file** in S3, so they never affect each other.

## Run locally (to try things out)

```powershell
cd terraform/environments/dev
terraform init
terraform plan
```

Real changes should go through the **Infra Pipeline** in GitHub Actions.
