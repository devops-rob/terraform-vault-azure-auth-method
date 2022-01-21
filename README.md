# Azure Auth Method for HashiCorp Vault

This Terraform module enables and configures teh Azure auth method in HashiCorp Vault to enable workload authentication from Azure to HashiCorp Vault.

## Pre-requisites

This module requires an Azure application registration, with a linked Service Principal, and a role assignment containing the following permissions:
- `Microsoft.Compute/virtualMachines/*/read`
- `Microsoft.Compute/virtualMachineScaleSets/*/read`

An Azure application registration can be provisioned using the [Azure AD Application Registration for HashiCorp Vault Terraform Module.](https://registry.terraform.io/modules/devops-rob/app-vault/azuread/latest)

## Example usage

```hcl
provider "vault" {
    address = "http://localhost:8200"
    token = var.token
}

provider "azuread" {}
provider "azurerm" {
    features {}
}

variable "token" {}

data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}

module "app-vault" {
  source  = "devops-rob/app-vault/azuread"
  version = "0.1.2"
  
  app_owners = [
      data.azuread_client_config.current.object_id
  ]
}

module "azure_auth"{
    source = "devops-rob/azure-auth-method/vault"

    client_id               = module.app-vault.application_id
    client_secret           = module.app-vault.client_secret
    tenant_id               = module.app-vault.tenant_id
    azuread_application_url = sort(module.app-vault.application_uri)[0]
}


resource "vault_azure_auth_backend_role" "azure_developers" {
  backend                         = module.azure_auth.path
  role                            = "azure-developers"
  token_ttl                       = 60
  token_max_ttl                   = 120

  token_policies                  = [
      "default"
  ]

  bound_subscription_ids = [
      data.azurerm_subscription.current.subscription_id
  ]
}

```

## License

Licensed under the Apache License, Version 2.0 (the "License").

You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _"AS IS"_ basis, without WARRANTIES or conditions of any kind, either express or implied.

See the License for the specific language governing permissions and limitations under the License.