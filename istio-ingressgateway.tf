locals {
  ingressgateway_backendconfig_name = "istio-ingressgateway"
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
    helm_release.istiod,
  ]
}

resource "kubernetes_manifest" "istio_ingressgateway_backendconfig" { # TODO Replace with kubectl
  count = local.istio.enabled && var.istio_ingressgateway_enabled ? 1 : 0
  manifest = {
    "apiVersion" = "cloud.google.com/v1"
    "kind"       = "BackendConfig"
    "metadata" = {
      "name"      = local.ingressgateway_backendconfig_name
      "namespace" = var.istio_ingressgateway_namespace
    }
    "spec" = {
      "healthCheck" = {
        checkIntervalSec = 10
        port             = 15021
        requestPath      = "/healthz/ready"
        timeoutSec       = 2
        type             = "HTTP"
      }
    }
  }

  depends_on = [
    kubernetes_namespace_v1.istio_ingressgateway_namespace
  ]
}

resource "helm_release" "ingressgateway" {
  /* count = local.istio.enabled && local.ingressgateway_enabled ? 1 : 0 */
  for_each = { for k, v in var.istio_ingressgateway_instance : k => v if var.istio_enabled && var.istio_ingressgateway_enabled } # TODO Review condition

  /* name             = "istio-ingressgateway-${each.value.major_version_suffix}" */ # FIXME Think
  name             = "istio-ingressgateway"
  repository       = local.istio.helm_repo
  chart            = "gateway"
  version          = each.value.version
  create_namespace = false
  namespace        = var.istio_ingressgateway_namespace

  values = [yamlencode(merge(var.istio_ingressgateway_common_helm_values, each.value.helm_values))]

  # Container-native load balancing
  # https://cloud.google.com/kubernetes-engine/docs/concepts/ingress#container-native_load_balancing
  # Service should be annotated automatically with: "cloud.google.com/neg: '{"ingress": true}'"

  depends_on = [
    helm_release.istiod,
    kubernetes_namespace_v1.istio_ingressgateway_namespace,
    kubernetes_manifest.istio_ingressgateway_backendconfig
  ]
}
