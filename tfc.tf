
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