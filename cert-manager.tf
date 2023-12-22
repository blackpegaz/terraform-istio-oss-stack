resource "kubernetes_namespace_v1" "cert_manager_namespace" {
  # count = local.istio.enabled && var.jaeger_operator_enabled ? 1 : 0 # FIXME Temp
  count = local.istio.enabled && var.cert_manager_enabled ? 1 : 0
  metadata {
    name = var.cert_manager_namespace
  }
}

# FIXME Manage CRDs

resource "helm_release" "cert_manager" {
  # count = local.istio.enabled && var.jaeger_operator_enabled ? 1 : 0 # FIXME Temp
  count = local.istio.enabled && var.cert_manager_enabled ? 1 : 0


  name             = "cert-manager"
  repository       = var.cert_manager_helm_repo
  chart            = "cert-manager"
  version          = var.cert_manager_version
  create_namespace = false
  namespace        = var.cert_manager_namespace

  values = [yamlencode(var.cert_manager_helm_values)]

  depends_on = [
    kubernetes_namespace_v1.cert_manager_namespace
  ]

}
