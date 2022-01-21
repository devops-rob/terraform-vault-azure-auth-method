# Azure AD variables
variable "client_id" {
  type        = string
  description = "The client id for credentials to query the Azure APIs."
}

variable "client_secret" {
  type        = string
  description = "The client secret for credentials to query the Azure APIs."
}

variable "tenant_id" {
  type        = string
  description = "The tenant id for the Azure Active Directory organization."
}

variable "max_lease_ttl" {
  type        = string
  default     = "9000s"
  description = "Specifies the maximum time-to-live. If set, this overrides the global default. Must be a valid duration string"
}

variable "azuread_application_url" {
  type        = string
  description = "The configured URL for the application registered in Azure Active Directory."
}

# Vault variables
variable "listing_visibility" {
  type        = string
  default     = "unauth"
  description = "Specifies whether to show this mount in the UI-specific listing endpoint. Valid values are `unauth` or `hidden`."
}

variable "resource" {
  type        = string
  default     = "https://management.azure.com/"
  description = "The configured URL for the application registered in Azure Active Directory."
}