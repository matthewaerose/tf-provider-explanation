# Refresher on how terraform providers work

## Introduction

Terraform providers are responsible for managing the lifecycle of a resource. They are the bridge between Terraform and the API of the service you want to manage. Providers are responsible for understanding API interactions, exposing resources, and managing the state of those resources.

Terraform providers are distributed as plugins. When you run `terraform init`, Terraform will download the provider plugin and install it in the `.terraform` directory. The provider plugin is responsible for translating the resource configuration into API calls and managing the state of the resources.

## The Parent-Child Relationship, w.r.t. Providers

Terraform providers are required to be configured at the root module level. This means setting the provider definition in a provider block.

```hcl
# the bare minimum for an 'aws' provider
provider "aws" {
  region = "us-west-2"
}
```

The provider block has a companion in the `required_providers` block, which is used to specify the version constraints for the provider.

```hcl
# a required_providers block for the 'aws' provider
# Note the pessimistic contraint `~> 3.0`
# This indicates that allows only the _rightmost_ version component to increment.
# other version constraints are documented [here](https://developer.hashicorp.com/terraform/language/expressions/version-constraints)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
```

Both the `required_providers` block and the `provider` blocks are required to be at the root module level. This means that the provider configuration is inherited by all child modules.

### Parent-child provider version mismatch

The issue with defining restrictive versions for providers in child modules is that it can lead to version conflicts. This is because the provider version is inherited from the parent module. If either the parent or the child define a version constraint that mismatches with the other, it will lead to a version conflict.

### Example

In the file `main.tf`, we define a `terraform.required_providers` block with "no operator" i.e. `=` which terraform defines as

> Allows only one exact version number. Cannot be combined with other conditions.

In the file `module.tf`, there are several commented out versions. Each has a comment next to it that indicates if it works or doesn't and why. Running `tf init` at the root, with the version uncommented, will show the error message that is produced.

## Conclusion

Children modules should either have open version constraints or no version constraints at all. This will allow the parent module to define the version constraint and the child module to inherit it. This will prevent version conflicts and make the module more flexible. Do note, that more flexible version constraints can lead to unexpected behavior if the provider changes in a way that is not backwards compatible.

tl;dr: Don't limit the parent modules ability to change provider versions because a child module has a restrictive version constraint.

Terraform has [this](https://developer.hashicorp.com/terraform/language/expressions/version-constraints#terraform-core-and-provider-versions) to say about provider version constraints.
