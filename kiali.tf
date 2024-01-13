locals {
  kiali_operator_url_crd_crds = "https://raw.githubusercontent.com/kiali/helm-charts/v${var.kiali_operator_version}/kiali-operator/crds/crds.yaml"
  kiali_operator_default_helm_values = templatefile("${path.module}/templates/istio-integrations/kiali/kiali-operator-default-helm-values.yaml.tftpl", {
    cr_spec_deployment_accessible_namespaces = jsonencode(distinct(flatten([[var.istio_istiod_namespace], [var.istio_ingressgateway_namespace], [var.kiali_operator_accessible_namespaces]]))),
    domain                                   = var.domain, # This is not the YAML path
    istio_stable_revision                    = local.istio.stable_revision,
    istio_oss_stack_default_nodeselector     = jsonencode(var.istio_oss_stack_default_nodeselector),                                                                                              # This is not the YAML path
    istiod_namespace                         = var.istio_istiod_namespace,                                                                                                                        # This is not the YAML path
    istio_ingressgateway_namespace           = var.istio_ingressgateway_namespace,                                                                                                                # This is not the YAML path
    jaeger_operator_namespace                = var.jaeger_operator_namespace,                                                                                                                     # This is not the YAML path
    prometheus_url                           = var.kube_prometheus_stack_enabled ? "http://kube-prometheus-stack-prometheus.${var.kube_prometheus_stack_namespace}.svc:9090" : var.prometheus_url # This is not the YAML path
  })
}

resource "kubernetes_namespace_v1" "kiali_operator_namespace" {
  count = var.istio_enabled && var.kiali_operator_enabled ? 1 : 0

  metadata {
    name = var.kiali_operator_namespace
  }

  lifecycle {
    ignore_changes  = [metadata]
    prevent_destroy = true
  }
}

data "http" "kiali_operator_crd_crds" {
  url = local.kiali_operator_url_crd_crds

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "kubectl_file_documents" "kiali_operator_crd_crds" {
  content = data.http.kiali_operator_crd_crds.response_body
}

resource "kubectl_manifest" "kiali_operator_crd_crds" {
  for_each          = { for k, v in data.kubectl_file_documents.kiali_operator_crd_crds.manifests : k => v if local.istio.enabled && var.kiali_operator_enabled }
  yaml_body         = each.value
  wait              = true
  server_side_apply = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "kiali_operator" {
  count = local.istio.enabled && var.kiali_operator_enabled ? 1 : 0

  name             = "kiali-operator"
  repository       = var.kiali_helm_repo
  chart            = "kiali-operator"
  version          = var.kiali_operator_version
  create_namespace = false
  namespace        = var.kiali_operator_namespace
  skip_crds        = true

  values = [
    local.kiali_operator_default_helm_values,
    yamlencode(var.kiali_operator_overlay_helm_values)
  ]

  depends_on = [
    helm_release.istio_istiod,
    helm_release.istio_ingressgateway,
    kubernetes_namespace_v1.kiali_operator_namespace,
    kubectl_manifest.kiali_operator_crd_crds
  ]

}
