locals {
  # TODO Review naming
  crds_split_doc  = split("---", data.helm_template.base_crds.manifest)
  crds_valid_yaml = [for doc in local.crds_split_doc : doc if try(yamldecode(doc).metadata.name, "") != ""]
  crds_dict       = { for doc in toset(local.crds_valid_yaml) : yamldecode(doc).metadata.name => doc }
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

data "helm_template" "base_crds" {
  name       = "istio-base"
  repository = local.istio.helm_repo
  chart      = "base"
  version    = var.istio_base_crds_version
  namespace  = var.istio_base_namespace

  set {
    name  = "base.enableCRDTemplates"
    value = "true"
  }

  show_only = [
    "templates/crds.yaml",
  ]

}

resource "kubectl_manifest" "base_crds" {
  for_each  = local.crds_dict
  yaml_body = each.value

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "base" {
  count = var.istio_enabled && var.istio_base_enabled ? 1 : 0

  name             = "istio-base"
  repository       = local.istio.helm_repo
  chart            = "base"
  version          = var.istio_base_version # TODO Implications ?
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
    kubectl_manifest.base_crds
  ]
}
