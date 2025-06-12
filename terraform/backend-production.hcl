bucket         = "cdc-terraform-state"
key            = "production/website/terraform.tfstate"
region         = "us-east-1"
profile        = "cdc-terraform"
encrypt        = true
dynamodb_table = "cdc-terraform-locks"