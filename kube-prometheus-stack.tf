locals {
  kube_prometheus_stack_default_helm_values = templatefile("${path.module}/templates/dependencies/non-prod-ready-kube-prometheus-stack-default-helm-values.yaml.tftpl", {
    istio_oss_stack_default_nodeselector = jsonencode(var.istio_oss_stack_default_nodeselector) # This is not the YAML path
  })
}

resource "kubernetes_namespace_v1" "kube_prometheus_stack_namespace" {
  count = var.kube_prometheus_stack_enabled ? 1 : 0
  metadata {
    name = var.kube_prometheus_stack_namespace
  }

  lifecycle {
    prevent_destroy = true
  }
}

# WARNING: CRDs are currently not managed 

resource "helm_release" "kube_prometheus_stack" {
  count = var.kube_prometheus_stack_enabled ? 1 : 0

  name             = "kube-prometheus-stack"
  repository       = var.kube_prometheus_stack_helm_repo
  chart            = "kube-prometheus-stack"
  version          = var.kube_prometheus_stack_version
  create_namespace = false
  namespace        = var.kube_prometheus_stack_namespace
  skip_crds        = false

  values = [
    local.kube_prometheus_stack_default_helm_values,
    yamlencode(var.kube_prometheus_stack_overlay_helm_values)
  ]

  depends_on = [
    kubernetes_namespace_v1.kube_prometheus_stack_namespace
  ]

}
