resource "kubernetes_namespace_v1" "kiali_operator_namespace" {
  count = var.istio_enabled && var.kiali_operator_enabled ? 1 : 0

  lifecycle {
    ignore_changes = [metadata]
  }

  metadata {
    name = var.kiali_operator_namespace
  }
}

# FIXME Manage CRDs

resource "helm_release" "kiali_operator" {
  count = local.istio.enabled && var.kiali_operator_enabled ? 1 : 0

  name             = "kiali-operator"
  repository       = var.kiali_helm_repo
  chart            = "kiali-operator"
  version          = var.kiali_operator_version
  create_namespace = false
  namespace        = var.kiali_operator_namespace

  values = [yamlencode(var.kiali_operator_helm_values)]

  depends_on = [
    helm_release.istiod,
    helm_release.ingressgateway,
    kubernetes_namespace_v1.kiali_operator_namespace
  ]

}
