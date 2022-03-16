resource "hcp_vault_cluster" "main" {
  cluster_id      = var.cluster_id
  hvn_id          = hcp_hvn.main.hvn_id
  public_endpoint = true
  tier            = var.vault_tier
}

resource "hcp_vault_cluster_admin_token" "main" {
  cluster_id = hcp_vault_cluster.main.cluster_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "helm_release" "vault" {
  depends_on = [module.eks, hcp_vault_cluster.main]
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.19.0"

  set {
    name  = "injector.enabled"
    value = "true"
  }

  set {
    name  = "injector.externalVaultAddr"
    value = hcp_vault_cluster.main.vault_private_endpoint_url
  }
}