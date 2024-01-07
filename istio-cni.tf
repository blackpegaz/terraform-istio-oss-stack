locals {
  cni_default_helm_values = templatefile("${path.module}/templates/istio-mesh/cni-default-helm-values.yaml.tftpl", {
    cnibindir = var.istio_platform == "gcp" ? "/home/kubernetes/bin" : ""
  })

  cni_version = var.istio_cni_version != "" ? var.istio_cni_version : var.istio_base_version
}

resource "helm_release" "istio_cni" {
  count = var.istio_enabled && var.istio_cni_enabled ? 1 : 0

  name       = "istio-cni"
  repository = local.istio.helm_repo
  chart      = "cni"
  version    = local.cni_version
  namespace  = var.istio_cni_namespace

  values = [
    local.cni_default_helm_values,
    yamlencode(var.istio_cni_overlay_helm_values)
  ]

  depends_on = [
    helm_release.istio_base
  ]
}
