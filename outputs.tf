output "istio" {
  description = "Informations regarding Istio installation."
  value = {
    canary_version          = local.istio.canary_version
    canary_revision         = local.istio.canary_revision
    stable_version          = local.istio.stable_version
    stable_revision         = local.istio.stable_revision
    old_stable_version      = local.istio.old_stable_version
    old_stable_revision     = local.istio.old_stable_revision
    ingressgateway_version  = var.istio_ingressgateway_version
    ingressgateway_revision = local.istio_ingressgateway_revision
    default_revision        = local.istio.default_revision
  }
}
