locals {
  url_base_crd_crdallgen = "https://raw.githubusercontent.com/istio/istio/${var.istio_base_crds_version}/manifests/charts/base/crds/crd-all.gen.yaml"
  url_base_crd_operator  = "https://raw.githubusercontent.com/istio/istio/${var.istio_base_crds_version}/manifests/charts/base/crds/crd-operator.yaml"
}

resource "kubernetes_namespace_v1" "istio_base_namespace" {
  count = var.istio_enabled && var.istio_base_enabled ? 1 : 0

  lifecycle {
    ignore_changes = [metadata]
  }

  metadata {
    name = var.istio_base_namespace
  }
}

data "http" "base_crd_crdallgen" {
  url = local.url_base_crd_crdallgen

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "kubectl_file_documents" "base_crd_crdallgen" {
  content = data.http.base_crd_crdallgen.response_body
}

resource "kubectl_manifest" "base_crd_crdallgen" {
  for_each          = { for k, v in data.kubectl_file_documents.base_crd_crdallgen.manifests : k => v if var.istio_enabled }
  yaml_body         = each.value
  wait              = true
  server_side_apply = true

  lifecycle {
    prevent_destroy = true
  }
}

data "http" "base_crd_operator" {
  url = local.url_base_crd_operator

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

data "kubectl_file_documents" "base_crd_operator" {
  content = data.http.base_crd_operator.response_body
}

resource "kubectl_manifest" "base_crd_operator" {
  for_each          = { for k, v in data.kubectl_file_documents.base_crd_operator.manifests : k => v if var.istio_enabled }
  yaml_body         = each.value
  wait              = true
  server_side_apply = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "base" {
  count = var.istio_enabled && var.istio_base_enabled ? 1 : 0

  name             = "istio-base"
  repository       = local.istio.helm_repo
  chart            = "base"
  version          = var.istio_base_version
  create_namespace = false
  namespace        = var.istio_base_namespace
  skip_crds        = true

  dynamic "set" {
    for_each = var.istio_platform != "" ? [""] : []
    content {
      name  = "global.platform"
      value = var.istio_platform
    }
  }

  values = [yamlencode(var.istio_base_common_helm_values)]

  depends_on = [
    kubernetes_namespace_v1.istio_base_namespace,
    kubectl_manifest.base_crd_crdallgen,
    kubectl_manifest.base_crd_operator
  ]
}
