locals {
  jaeger_operator_url_crd_crds = "https://raw.githubusercontent.com/jaegertracing/helm-charts/jaeger-operator-${var.jaeger_operator_version}/charts/jaeger-operator/crds/crd.yaml"
  jaeger_operator_default_helm_values = templatefile("${path.module}/templates/istio-integrations/jaeger/jaeger-operator-default-helm-values.yaml.tftpl", {
    nodeselector = jsonencode(var.istio_oss_stack_default_nodeselector)
  })
}

resource "kubernetes_namespace_v1" "jaeger_operator_namespace" {
  count = local.istio.enabled && var.jaeger_operator_enabled ? 1 : 0

  metadata {
    name = var.jaeger_operator_namespace
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "http" "jaeger_operator_crd_crds" {
  url = local.jaeger_operator_url_crd_crds

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "kubectl_file_documents" "jaeger_operator_crd_crds" {
  content = data.http.jaeger_operator_crd_crds.response_body
}

resource "kubectl_manifest" "jaeger_operator_crd_crds" {
  for_each          = { for k, v in data.kubectl_file_documents.jaeger_operator_crd_crds.manifests : k => v if local.istio.enabled && var.jaeger_operator_enabled }
  yaml_body         = each.value
  wait              = true
  server_side_apply = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "jaeger_operator" {
  count = local.istio.enabled && var.jaeger_operator_enabled ? 1 : 0

  name             = "jaeger-operator"
  repository       = var.jaeger_helm_repo
  chart            = "jaeger-operator"
  version          = var.jaeger_operator_version
  create_namespace = false
  namespace        = var.jaeger_operator_namespace
  skip_crds        = true

  values = [
    local.jaeger_operator_default_helm_values,
    yamlencode(var.jaeger_operator_overlay_helm_values)
  ]

  depends_on = [
    helm_release.cert_manager,
    kubernetes_namespace_v1.jaeger_operator_namespace,
    kubectl_manifest.jaeger_operator_crd_crds
  ]

}

resource "kubectl_manifest" "jaeger_operator_instance_allinone" {
  count = local.istio.enabled && var.jaeger_operator_enabled && var.jaeger_operator_create_instance_allinone ? 1 : 0
  yaml_body = templatefile("${path.module}/templates/istio-integrations/jaeger/jaeger-operator-instance-allinone.yaml.tftpl", {
    name                        = "jaeger",
    namespace                   = var.jaeger_operator_namespace,
    spec_allinone_image_version = var.jaeger_operator_instance_allinone_image_version
    affinity                    = jsonencode(var.jaeger_operator_instance_allinone_affinity)
  })

  depends_on = [
    helm_release.jaeger_operator
  ]
}
