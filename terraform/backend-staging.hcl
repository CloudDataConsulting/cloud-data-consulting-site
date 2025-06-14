bucket         = "cdc-terraform-state-241661645686"
key            = "staging/website/terraform.tfstate"
region         = "us-east-1"
profile        = "cdc-prd"
encrypt        = true
dynamodb_table = "cdc-terraform-locks"