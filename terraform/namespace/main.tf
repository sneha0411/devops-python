resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace

    labels = {
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}
