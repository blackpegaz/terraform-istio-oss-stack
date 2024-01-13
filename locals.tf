locals {
  /* common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/version"    = var.istio_version
  } */

  istio = {
    enabled   = var.istio_enabled
    helm_repo = var.istio_helm_repo
    revisiontags = {
      stable = distinct(concat(["default"], [var.revisiontags_stable]))
      canary = var.revisiontags_canary
    }
    stable_version = element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["version"] if instance_config["revisiontags_binding"] == "stable"
    ], 0)
    stable_revision = element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["revision"] if instance_config["revisiontags_binding"] == "stable"
    ], 0)
    canary_version = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["version"] if instance_config["revisiontags_binding"] == "canary"
    ], 0), "")
    canary_revision = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["revision"] if instance_config["revisiontags_binding"] == "canary"
    ], 0), "")
  }

}
