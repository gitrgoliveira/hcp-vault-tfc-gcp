provider "vault" {
  namespace = "admin"
  address   = var.vault_address
}

resource "vault_namespace" "instruqt" {
  path = "instruqt"
}

resource "vault_jwt_auth_backend" "tfc" {
  namespace          = vault_namespace.instruqt.namespace
  description        = "Terraform Cloud JWT auth backend"
  path               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
  default_role       = "admin"
}

resource "vault_policy" "admin" {
  namespace = vault_namespace.instruqt.namespace
  name      = "admin"
  policy    = <<EOP
    # Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

# allow manage namespaces
path "sys/namespaces/*" {
  capabilities = ["create", "read", "update", "delete", "list", "patch"]
}

# allow new mounts 
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "patch"]
}

# admin policy
path "*" {
capabilities = ["create", "read", "update", "delete", "list", "patch", "sudo"]
}

EOP

}

resource "vault_jwt_auth_backend_role" "admin" {
  namespace         = vault_namespace.instruqt.namespace
  backend           = vault_jwt_auth_backend.tfc.path
  role_name         = "admin"
  role_type         = "jwt"
  user_claim        = "terraform_full_workspace"
  bound_audiences   = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    # "organization:my-org-name:project:my-project-name:workspace:my-workspace-name:run_phase:*"
    sub = "organization:${var.terraform_organization}:project:${tfe_project.vault-gcp.name}:workspace:*",
  }

  token_policies = [vault_policy.admin.name]
  token_max_ttl  = 1200
}
