provider "google" {
}

data "google_project" "current" {
}
resource "google_service_account" "secrets_engine" {
  account_id   = "vault-secrets-engine"
  display_name = "Vault Secrets Engine"
}
resource "google_project_iam_member" "secrets_engine" {
  for_each = toset([
    "roles/editor",
    "roles/resourcemanager.projectIamAdmin"
  ])
  project = data.google_project.current.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.secrets_engine.email}"
}

resource "google_service_account_key" "secrets_engine_key" {
  service_account_id = google_service_account.secrets_engine.name
}

resource "vault_gcp_secret_backend" "google" {
  namespace   = vault_namespace.instruqt.namespace
  path        = "tfc-gcp"
  credentials = base64decode(google_service_account_key.secrets_engine_key.private_key)
}
