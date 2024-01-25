# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "terra-dev-remote-state-2023"
    key            = "nethermind/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-Dev-user"
    dynamodb_table = "terraform-state-lock"
  }
}
