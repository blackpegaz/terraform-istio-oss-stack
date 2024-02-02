## Default tag (https://istio.io/latest/docs/setup/upgrade/helm/#default-tag)

data "helm_template" "istio_istiod_revisiontags_default" {

  name             = "istio-istiod-revisiontags-default"
  repository       = local.istio.helm_repo
  chart            = "istiod"
  version          = local.istio.stable_version
  create_namespace = false
  namespace        = var.istio_istiod_namespace

  show_only = [
    "templates/revision-tags.yaml",
  ]

  set_list {
    name  = "revisionTags"
    value = ["default"]
  }

  set {
    name  = "revision"
    value = local.istio.default_revision
  }

}

data "kubectl_file_documents" "istio_istiod_revisiontags_default_docs" {
  content = data.helm_template.istio_istiod_revisiontags_default.manifest
}

resource "kubectl_manifest" "istio_istiod_revisiontags_default" {
  for_each         = { for doc in toset([for doc in data.kubectl_file_documents.istio_istiod_revisiontags_default_docs.manifests : doc if try(yamldecode(doc).metadata.name, "") != ""]) : yamldecode(doc).metadata.name => doc }
  sensitive_fields = ["webhooks"]
  yaml_body        = each.value

  depends_on = [
    helm_release.istio_istiod
  ]
}

## "Stable" tag

data "helm_template" "istio_istiod_revisiontags_stable" {

  name             = "istio-istiod-revisiontags-stable"
  repository       = local.istio.helm_repo
  chart            = "istiod"
  version          = local.istio.stable_version
  create_namespace = false
  namespace        = var.istio_istiod_namespace

  show_only = [
    "templates/revision-tags.yaml",
  ]

  set_list {
    name  = "revisionTags"
    value = [local.istio.revisiontags.stable]
  }

  set {
    name  = "revision"
    value = local.istio.stable_revision
  }

}

data "kubectl_file_documents" "istio_istiod_revisiontags_stable_docs" {
  content = data.helm_template.istio_istiod_revisiontags_stable.manifest
}

resource "kubectl_manifest" "istio_istiod_revisiontags_stable" {
  for_each         = { for doc in toset([for doc in data.kubectl_file_documents.istio_istiod_revisiontags_stable_docs.manifests : doc if try(yamldecode(doc).metadata.name, "") != ""]) : yamldecode(doc).metadata.name => doc }
  sensitive_fields = ["webhooks"]
  yaml_body        = each.value

  depends_on = [
    helm_release.istio_istiod
  ]
}

## "Canary" tag

data "helm_template" "istio_istiod_revisiontags_canary" {
  /* count = local.istio.canary_version != "" ? 1 : 0 */ #FIXME

  name             = "istio-istiod-revisiontags-canary"
  repository       = local.istio.helm_repo
  chart            = "istiod"
  version          = local.istio.canary_version
  create_namespace = false
  namespace        = var.istio_istiod_namespace

  show_only = [
    "templates/revision-tags.yaml",
  ]

  set_list {
    name  = "revisionTags"
    value = [local.istio.revisiontags.canary]
  }

  set {
    name  = "revision"
    value = local.istio.canary_revision
  }

}

data "kubectl_file_documents" "istio_istiod_revisiontags_canary_docs" {
  /* count = local.istio.canary_version != "" ? 1 : 0 */ #FIXME
  content = data.helm_template.istio_istiod_revisiontags_canary.manifest
}

resource "kubectl_manifest" "istio_istiod_revisiontags_canary" {
  for_each = { for doc in toset([
    for doc in data.kubectl_file_documents.istio_istiod_revisiontags_canary_docs.manifests : doc
    if try(yamldecode(doc).metadata.name, "") != ""]) : yamldecode(doc).metadata.name => doc
  if local.istio.canary_version != "" }

  sensitive_fields = ["webhooks"]
  yaml_body        = each.value

  depends_on = [
    helm_release.istio_istiod
  ]
}

## "Old stable" tag

data "helm_template" "istio_istiod_revisiontags_old_stable" {
  /* count = local.istio.old_stable_version != "" ? 1 : 0 */ #FIXME

  name             = "istio-istiod-revisiontags-old-stable"
  repository       = local.istio.helm_repo
  chart            = "istiod"
  version          = local.istio.old_stable_version
  create_namespace = false
  namespace        = var.istio_istiod_namespace

  show_only = [
    "templates/revision-tags.yaml",
  ]

  set_list {
    name  = "revisionTags"
    value = [local.istio.revisiontags.old-stable]
  }

  set {
    name  = "revision"
    value = local.istio.old_stable_revision
  }

}

data "kubectl_file_documents" "istio_istiod_revisiontags_old_stable_docs" {
  /* count = local.istio.old_stable_version != "" ? 1 : 0 */ #FIXME
  content = data.helm_template.istio_istiod_revisiontags_old_stable.manifest
}

resource "kubectl_manifest" "istio_istiod_revisiontags_old_stable" {
  for_each = { for doc in toset([
    for doc in data.kubectl_file_documents.istio_istiod_revisiontags_old_stable_docs.manifests : doc
    if try(yamldecode(doc).metadata.name, "") != ""]) : yamldecode(doc).metadata.name => doc
  if local.istio.old_stable_version != "" }

  sensitive_fields = ["webhooks"]
  yaml_body        = each.value

  depends_on = [
    helm_release.istio_istiod
  ]
}
