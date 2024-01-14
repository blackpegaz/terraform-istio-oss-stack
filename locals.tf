locals {
  /* common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/version"    = var.istio_version
  } */

  istio = {
    enabled   = var.istio_enabled
    helm_repo = var.istio_helm_repo
    revisiontags = {
      canary     = var.revisiontags_canary
      stable     = var.revisiontags_stable
      old-stable = var.revisiontags_old_stable
    }
    canary_version = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["version"] if instance_config["revisiontags_binding"] == "canary"
    ], 0), "")
    canary_revision = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["revision"] if instance_config["revisiontags_binding"] == "canary"
    ], 0), "")
    stable_version = element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["version"] if instance_config["revisiontags_binding"] == "stable"
    ], 0)
    stable_revision = element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["revision"] if instance_config["revisiontags_binding"] == "stable"
    ], 0)
    old_stable_version = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["version"] if instance_config["revisiontags_binding"] == "old-stable"
    ], 0), "")
    old_stable_revision = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["revision"] if instance_config["revisiontags_binding"] == "old-stable"
    ], 0), "")
    default_revision = try(element([
      for instance, instance_config in var.istio_istiod_instance : instance_config["revision"] if instance_config["revisiontags_binding"] == "stable" && tobool(instance_config["is_default_revision"]) == true
    ], 0), "")
  }

}
