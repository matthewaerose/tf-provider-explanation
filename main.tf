terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16.0"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.12.0"
    }
  }
}

module "foo" {
  source = "./modules/datadog"
}

provider "datadog" {
  api_key = ""
  app_key = ""
}
