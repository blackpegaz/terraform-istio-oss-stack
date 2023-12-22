locals {
  /* common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/version"    = var.istio_version
  } */

  istio = {
    enabled   = var.istio_enabled
    helm_repo = var.istio_helm_repo
  }

  # distribution_helm_values = lookup(local.per_distribution_helm_values, var.distribution, {})
  # default_istiod_helm_values  = concat(lookup(local.distribution_helm_values, "istiod", []), local.cni_helm_values)
  # { values = concat(local.default_base_helm_values, lookup(var.base_helm_config, "values", [])) }

}
