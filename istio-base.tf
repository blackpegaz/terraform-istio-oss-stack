locals {
  base_crds_version      = var.istio_base_crds_version != "" ? var.istio_base_crds_version : coalesce(local.istio.canary_version, local.istio.stable_version)
  base_url_crd_crdallgen = "https://raw.githubusercontent.com/istio/istio/${local.base_crds_version}/manifests/charts/base/crds/crd-all.gen.yaml"
  base_url_crd_operator  = "https://raw.githubusercontent.com/istio/istio/${local.base_crds_version}/manifests/charts/base/crds/crd-operator.yaml"

  base_default_helm_values = templatefile("${path.module}/templates/istio-mesh/base-default-helm-values.yaml.tftpl", {
    defaultrevision = local.istio.stable_revision,
    platform        = var.istio_platform
  })

  base_version = var.istio_base_version != "" ? var.istio_base_version : local.istio.stable_version
}

resource "kubernetes_namespace_v1" "istio_base_namespace" {
  count = var.istio_enabled && var.istio_base_enabled ? 1 : 0

  metadata {
    name = var.istio_base_namespace
  }

  lifecycle {
    ignore_changes  = [metadata]
    prevent_destroy = true
  }
}

data "http" "base_crd_crdallgen" {
  url = local.base_url_crd_crdallgen

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
  url = local.base_url_crd_operator

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

resource "helm_release" "istio_base" {
  count = var.istio_enabled && var.istio_base_enabled ? 1 : 0

  name             = "istio-base"
  repository       = local.istio.helm_repo
  chart            = "base"
  version          = local.base_version
  create_namespace = false
  namespace        = var.istio_base_namespace
  skip_crds        = true

  values = [
    local.base_default_helm_values,
    yamlencode(var.istio_base_overlay_helm_values),
  ]

  depends_on = [
    kubernetes_namespace_v1.istio_base_namespace,
    kubectl_manifest.base_crd_crdallgen,
    kubectl_manifest.base_crd_operator
  ]
}
