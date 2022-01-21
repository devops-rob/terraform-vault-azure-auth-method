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
