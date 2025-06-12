bucket         = "cdc-terraform-state"
key            = "staging/website/terraform.tfstate"
region         = "us-east-1"
profile        = "cdc-terraform"
encrypt        = true
dynamodb_table = "cdc-terraform-locks"