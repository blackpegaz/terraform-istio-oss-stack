output "istio" {
  description = "Informations regarding Istio installation."
  value = {
    stable_version          = local.istio.stable_version
    stable_revision         = local.istio.stable_revision
    canary_version          = local.istio.canary_version
    canary_revision         = local.istio.canary_revision
    ingressgateway_version  = var.istio_ingressgateway_version
    ingressgateway_revision = local.istio_ingressgateway_revision
  }
}
