locals {
  istio_ingressgateway_revision = var.istio_ingressgateway_revision_binding == "stable" ? var.revisiontags_stable : (var.istio_ingressgateway_revision_binding == "canary" ? var.revisiontags_canary : var.revisiontags_old_stable)

  istio_ingressgateway_default_helm_values = templatefile("${path.module}/templates/istio-ingressgateway/istio-ingressgateway-default-helm-values.yaml.tftpl", {
    jaeger_spec_nodeselector                = jsonencode(var.istio_oss_stack_default_nodeselector),
    nodeselector                            = jsonencode(var.istio_oss_stack_default_nodeselector),
    revision                                = local.istio_ingressgateway_revision
    istio_ingressgateway_backendconfig_name = var.istio_ingressgateway_backendconfig_name # This is not the YAML path
  })
}

resource "kubernetes_namespace_v1" "istio_ingressgateway_namespace" {
  count = local.istio.enabled && var.istio_ingressgateway_enabled && var.istio_ingressgateway_create_namespace ? 1 : 0

  lifecycle {
    ignore_changes  = [metadata]
    prevent_destroy = true
  }

  metadata {
    name = var.istio_ingressgateway_namespace
  }

  depends_on = [
    helm_release.istio_istiod,
  ]
}

resource "kubectl_manifest" "istio_ingressgateway_backendconfig" {
  count = local.istio.enabled && var.istio_platform == "gcp" && var.istio_ingressgateway_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/templates/istio-ingressgateway/istio-ingressgateway-backendconfig.yaml.tftpl", {
    name      = var.istio_ingressgateway_backendconfig_name,
    namespace = var.istio_ingressgateway_namespace
  })

  depends_on = [
    kubernetes_namespace_v1.istio_ingressgateway_namespace
  ]
}

resource "helm_release" "istio_ingressgateway" {
  count = local.istio.enabled && var.istio_ingressgateway_enabled ? 1 : 0

  name             = "istio-ingressgateway"
  repository       = local.istio.helm_repo
  chart            = "gateway"
  version          = var.istio_ingressgateway_version
  create_namespace = false
  namespace        = var.istio_ingressgateway_namespace

  values = [
    local.istio_ingressgateway_default_helm_values,
    yamlencode(var.istio_ingressgateway_overlay_helm_values)
  ]

  lifecycle {
    precondition {
      condition     = anytrue([for instance in var.istio_istiod_instance : contains([var.istio_ingressgateway_revision_binding], instance.revisiontags_binding)])
      error_message = "[ERR-ISTIO-21] The \"istio_ingressgateway_revision_binding\" variable does not bind an existing Istiod instance."
    }
  }

  depends_on = [
    helm_release.istio_istiod,
    kubernetes_namespace_v1.istio_ingressgateway_namespace,
    kubectl_manifest.istio_ingressgateway_backendconfig
  ]
}

resource "kubectl_manifest" "istio_ingressgateway_shared_secured_gateway" {
  count = local.istio.enabled && var.istio_ingressgateway_enabled && var.istio_ingressgateway_create_shared_secured_gateway ? 1 : 0
  yaml_body = templatefile("${path.module}/templates/istio-ingressgateway/istio-ingressgateway-shared-secured-gateway.yaml.tftpl", {
    name           = var.istio_ingressgateway_shared_secured_gateway_name,
    namespace      = var.istio_ingressgateway_shared_secured_gateway_namespace
    credentialname = "istio-ingressgateway" # FIXME
  })

  depends_on = [
    kubernetes_namespace_v1.istio_ingressgateway_namespace,
    helm_release.istio_ingressgateway
  ]
}
