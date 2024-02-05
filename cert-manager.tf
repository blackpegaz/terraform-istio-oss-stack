locals {
  cert_manager_url_crd_crds = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_manager_version}/cert-manager.crds.yaml"
  cert_manager_default_helm_values = templatefile("${path.module}/templates/dependencies/cert-manager-default-helm-values.yaml.tftpl", {
    istio_oss_stack_default_nodeselector = jsonencode(var.istio_oss_stack_default_nodeselector) # This is not the YAML path
  })
}

resource "kubernetes_namespace_v1" "cert_manager_namespace" {
  count = local.istio.enabled && var.jaeger_operator_enabled && var.cert_manager_enabled ? 1 : 0
  metadata {
    name = var.cert_manager_namespace
  }

  lifecycle {
    prevent_destroy = true
  }
}

data "http" "cert_manager_crd_crds" {
  url = local.cert_manager_url_crd_crds

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "kubectl_file_documents" "cert_manager_crd_crds" {
  content = data.http.cert_manager_crd_crds.response_body
}

resource "kubectl_manifest" "cert_manager_crd_crds" {
  for_each          = { for k, v in data.kubectl_file_documents.cert_manager_crd_crds.manifests : k => v if local.istio.enabled && var.jaeger_operator_enabled && var.cert_manager_enabled }
  sensitive_fields  = var.crds_sensitive_fields
  yaml_body         = each.value
  wait              = true
  server_side_apply = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "cert_manager" {
  count = local.istio.enabled && var.jaeger_operator_enabled && var.cert_manager_enabled ? 1 : 0

  name             = "cert-manager"
  repository       = var.cert_manager_helm_repo
  chart            = "cert-manager"
  version          = var.cert_manager_version
  create_namespace = false
  namespace        = var.cert_manager_namespace
  skip_crds        = true

  values = [
    local.cert_manager_default_helm_values,
    yamlencode(var.cert_manager_overlay_helm_values)
  ]

  depends_on = [
    kubernetes_namespace_v1.cert_manager_namespace,
    kubectl_manifest.cert_manager_crd_crds
  ]

}
