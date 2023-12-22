resource "helm_release" "istiod" {
  for_each = { for k, v in var.istio_istiod_instance : k => v if var.istio_enabled && var.istio_istiod_enabled }

  name       = "istio-istiod-${each.value.helm_values["revision"]}"
  repository = local.istio.helm_repo
  chart      = "istiod"
  version    = each.value.version
  namespace  = var.istio_istiod_namespace

  values = [yamlencode(merge(var.istio_istiod_common_helm_values, each.value.helm_values))]

  depends_on = [
    kubernetes_namespace_v1.istio_base_namespace,
    helm_release.base,
    helm_release.cni
  ]
}
