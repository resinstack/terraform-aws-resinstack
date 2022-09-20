terraform {
  required_providers {
    linuxkit = {
      source  = "resinstack/linuxkit"
      version = "0.0.7"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.31.0"
    }
  }
}

provider "aws" {}
provider "linuxkit" {}
