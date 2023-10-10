
provider "tfe" {
}

resource "tfe_project" "vault-gcp" {
  name = "VAULT-GCP"
}

resource "tfe_project_variable_set" "bootstrap_vault_trust" {
  project_id      = tfe_project.vault-gcp.id
  variable_set_id = tfe_variable_set.vault-trust-gcp.id
}

resource "tfe_variable_set" "vault-trust-gcp" {
  name        = "vault-trust-gcp"
  description = "Variables for Vault access"
  global      = false
}

resource "tfe_variable" "TFC_VAULT_PROVIDER_AUTH" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_PROVIDER_AUTH"
  value    = true
}

resource "tfe_variable" "TFC_VAULT_ADDR" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_ADDR"
  value    = var.vault_address
}

resource "tfe_variable" "VAULT_ADDR" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "VAULT_ADDR"
  value    = var.vault_address
}

resource "tfe_variable" "TFC_VAULT_NAMESPACE" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_NAMESPACE"
  value    = vault_jwt_auth_backend_role.admin.namespace
}
resource "tfe_variable" "TFC_VAULT_AUTH_PATH" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_AUTH_PATH"
  value    = vault_jwt_auth_backend.tfc.path
}

resource "tfe_variable" "TFC_VAULT_RUN_ROLE" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_RUN_ROLE"
  value    = vault_jwt_auth_backend_role.admin.role_name
}
# resource "tfe_variable" "TFC_VAULT_ENCODED_CACERT" {
#   variable_set_id = tfe_variable_set.vault-trust-gcp.id

#   category = "env"
#   key      = "TFC_VAULT_ENCODED_CACERT"
#   value    = data.tfe_outputs.vault-gcp.values.vault_ca
#   sensitive = true
# }

##############################################################################



resource "tfe_variable" "TFC_VAULT_BACKED_GCP_AUTH" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_BACKED_GCP_AUTH"
  value    = "true"
}
resource "tfe_variable" "TFC_VAULT_BACKED_GCP_AUTH_TYPE" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_BACKED_GCP_AUTH_TYPE"
  # Specifies the type of authentication to perform with GCP. Must be one of the following: roleset/access_token, roleset/service_account_key, static_account/access_token, or static_account/service_account_key.
  value = "roleset/service_account_key"
}

resource "tfe_variable" "TFC_VAULT_BACKED_GCP_MOUNT_PATH" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_BACKED_GCP_MOUNT_PATH"
  value    = vault_gcp_secret_backend.google.path
}

# These environment variables are only valid if the TFC_VAULT_BACKED_GCP_AUTH_TYPE is roleset/access_token or roleset/service_account_key.
# https://developer.hashicorp.com/terraform/enterprise/workspaces/dynamic-provider-credentials/vault-backed/gcp-configuration#roleset-specific-environment-variables
resource "tfe_variable" "TFC_VAULT_BACKED_GCP_RUN_VAULT_ROLESET" {
  variable_set_id = tfe_variable_set.vault-trust-gcp.id

  category = "env"
  key      = "TFC_VAULT_BACKED_GCP_RUN_VAULT_ROLESET"
  value    = vault_gcp_secret_roleset.editor_roleset.roleset
}

