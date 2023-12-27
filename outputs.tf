output "istio_base_helm_metadata" {
  description = "block status of the istio base helm release"
  value       = length(helm_release.istio_base) > 0 ? helm_release.istio_base[0].metadata : null
}

output "istio_cni_helm_metadata" {
  description = "block status of the istio cni helm release"
  value       = length(helm_release.istio_cni) > 0 ? helm_release.istio_cni[0].metadata : null
}

/* output "istio_istiod_helm_metadata" {
  description = "block status of the istio istiod helm release"
  value       = length(helm_release.istiod) > 0 ? helm_release.istiod[0].metadata : null
} */

output "istio_ingressgateway_helm_metadata" {
  description = "block status of the istio gateway helm release"
  value       = length(helm_release.istio_ingressgateway) > 0 ? helm_release.istio_ingressgateway[0].metadata : null
}
