locals {
  istiod_default_helm_values = templatefile("${path.module}/templates/istio-mesh/istiod-default-helm-values.yaml.tftpl", {
    cni_enabled               = var.istio_cni_enabled,
    pilot_nodeselector        = jsonencode(var.istio_oss_stack_default_nodeselector),
    jaeger_operator_enabled   = var.jaeger_operator_enabled,  # This is not the YAML path
    jaeger_operator_namespace = var.jaeger_operator_namespace # This is not the YAML path
  })
}

resource "helm_release" "istio_istiod" {
  for_each = { for instance, instance_config in var.istio_istiod_instance : instance => instance_config if var.istio_enabled && var.istio_istiod_enabled }

  name             = "istio-istiod-${each.value.revision}"
  repository       = local.istio.helm_repo
  chart            = "istiod"
  version          = each.value.version
  create_namespace = false
  namespace        = var.istio_istiod_namespace

  values = [
    local.istiod_default_helm_values,
    yamlencode(var.istio_istiod_overlay_helm_values),
    yamlencode({ "revision" : each.value.revision }),
    yamlencode(each.value.helm_values)
  ]

  depends_on = [
    kubernetes_namespace_v1.istio_base_namespace,
    helm_release.istio_base,
    helm_release.istio_cni
  ]
}
