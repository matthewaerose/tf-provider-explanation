# Note how there is no AWS provider here, but it is still used in the root main.tf
terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
      # version = "3.11.0"    # this fails, as it is different from the root main.tf
      # version = "< 3.12.0"  # this fails, as it is a range that excludes the root main.tf
      # version = "!= 3.12.0" # this fails, as it is a range that excludes the root main.tf

      # version = "3.12.0"    # this works, as it is the same as the root main.tf
      # version = "~> 3"      # this works, as it is a range that includes the root main.tf
      # version = ">= 3.12.0" # this works, as it is a range that includes the root main.tf
    }
  }
}

data "datadog_role" "admin" {
  filter = "Datadog Admin Role"
}
