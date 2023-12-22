resource "kubernetes_namespace_v1" "jaeger_operator_namespace" {
  count = local.istio.enabled && var.jaeger_operator_enabled ? 1 : 0
  metadata {
    name = var.jaeger_operator_namespace
  }
}

# FIXME Manage CRDs

resource "helm_release" "jaeger" {
  count = local.istio.enabled && var.jaeger_operator_enabled ? 1 : 0

  name             = "jaeger-operator"
  repository       = var.jaeger_helm_repo
  chart            = "jaeger-operator"
  version          = var.jaeger_operator_version
  create_namespace = false
  namespace        = var.jaeger_operator_namespace

  values = [yamlencode(var.jaeger_operator_helm_values)]

  depends_on = [
    helm_release.cert_manager,
    kubernetes_namespace_v1.jaeger_operator_namespace
  ]

}
