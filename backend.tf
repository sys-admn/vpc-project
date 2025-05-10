terraform {
  backend "s3" {
    bucket = "york-terraform-state"
    key    = "weekly-modules"
    region = "us-west-2"
  }
}

