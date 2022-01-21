resource "vault_auth_backend" "azure" {
  type = "azure"

  tune {
    max_lease_ttl      = var.max_lease_ttl
    listing_visibility = var.listing_visibility
  }
}

resource "vault_azure_auth_backend_config" "azure" {
  backend       = vault_auth_backend.azure.path
  tenant_id     = var.tenant_id
  client_id     = var.client_id
  client_secret = var.client_secret
  resource      = var.resource
}

