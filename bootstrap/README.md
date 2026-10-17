# Bootstrap (run once from your laptop)

This folder creates the things the pipeline needs **before** it can run:

| File | Creates |
|---|---|
| `oidc.tf` | Lets AWS trust GitHub's login service (OIDC) |
| `iam_terraform.tf` | The role the Terraform pipeline logs in with |

These are kept **outside** the `terraform/` folder on purpose.
So `terraform destroy` in `terraform/` never deletes them, and the
pipeline can always log in and rebuild everything.

## How to run

```powershell
cd bootstrap
terraform init
terraform apply
```

You only need to run this again if you change a file in this folder.
