resource "helm_release" "cni" {
  count = var.istio_enabled && var.istio_cni_enabled ? 1 : 0

  name       = "istio-cni"
  repository = local.istio.helm_repo
  chart      = "cni"
  version    = var.istio_cni_version
  namespace  = var.istio_cni_namespace

  dynamic "set" {
    for_each = var.istio_platform == "gcp" ? [""] : []
    content {
      name  = "cni.cniBinDir"
      value = "/home/kubernetes/bin"
    }
  }

  depends_on = [
    helm_release.base
  ]
}
