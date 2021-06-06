terraform {
  backend "remote" {
    organization = "kyree-terraform"

    workspaces {
      name = "kyree-dev"
    }
  }
}