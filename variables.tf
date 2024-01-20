### Global ###
variable "domain" {
  description = <<EOT
  The FQDN used to configure external urls"

  Example: "example.com"
  EOT
  type        = string
}

variable "istio_oss_stack_default_nodeselector" {
  description = <<EOT
  Map of key/value pairs used to configure nodeSelector for the entire stack.

  Example: {"disktype":"ssd"}
  }
  EOT
  type        = map(any)
  default     = {}
}

variable "prometheus_url" {
  description = <<EOT
  The URL used to query the Prometheus Server.

  Example: "http://kube-prometheus-stack-prometheus.monitoring.svc:9090"
  EOT
  type        = string
  default     = ""
}

variable "crds_sensitive_fields" {
  description = "List of fields (dot-syntax) which are sensitive and should be obfuscated in output. This feature is used here to reduce the size of the output for the CRDs."
  type        = list(any)
  default     = ["spec.versions"]
}

#### ISTIO #### 
variable "istio_enabled" {
  description = "Flag to enable or disable the installation of all istio components"
  type        = bool
  default     = true
}

variable "istio_helm_repo" {
  description = "The URL of the Istio Helm repository"
  type        = string
  default     = "https://istio-release.storage.googleapis.com/charts"
}

variable "istio_platform" {
  description = <<EOT
  (Optional) Platform where Istio is deployed. Possible values are: "openshift", "gcp", "".
  An empty value means it is a vanilla Kubernetes distribution, therefore no special treatment will be considered.

  Default: ""
  EOT
  validation {
    condition = contains(
      ["", "gcp", "openshift"],
      var.istio_platform
    )
    error_message = "Err: platform is not valid."
  }
  default = ""
}

# istio/base
variable "istio_base_enabled" {
  description = "Flag to enable or disable the installation of istio-base components"
  type        = bool
  default     = true
}

variable "istio_base_namespace" {
  description = "The name of the istio-base namespace"
  type        = string
  default     = "istio-system"
}

variable "istio_base_crds_version" {
  description = "The version of the istio-base CRDs"
  type        = string
  default     = ""
}

variable "istio_base_version" {
  description = "The version of the istio-base Helm release"
  type        = string
  default     = ""
}

variable "istio_base_overlay_helm_values" {
  description = "Any values to pass as an overlay to the istio-base Helm values"
  type        = any
  default     = {}
}

# istio/cni
variable "istio_cni_enabled" {
  description = "Flag to enable or disable the installation of istio-cni components"
  type        = bool
  default     = true
}

variable "istio_cni_version" {
  description = "The version of the istio-cni Helm release"
  type        = string
  default     = ""
}

variable "istio_cni_namespace" {
  description = "The name of the istio-cni namespace"
  type        = string
  default     = "kube-system"
}

variable "istio_cni_overlay_helm_values" {
  description = "Any values to pass as an overlay to the istio-cni Helm values"
  type        = any
  default     = {}
}

# istio/istiod
variable "istio_istiod_enabled" {
  description = "Flag to enable or disable the installation of istio-istiod components"
  type        = bool
  default     = true
}

variable "istio_istiod_namespace" {
  description = "The name of the istio-istiod namespace"
  type        = string
  default     = "istio-system"
}

variable "istio_istiod_overlay_helm_values" {
  description = "Any values to pass as an overlay to the istio-istiod Helm values"
  type        = any
  default     = {}
}

variable "revisiontags_stable" {
  description = "The name of the \"revisionTag\" which is bound to the \"stable\" Istio revision. Your app should reference this revisionTag when there is no canary upgrade in progress."
  type        = string
  default     = "prod-stable"
  validation {
    condition     = !contains(["default"], lower(var.revisiontags_stable))
    error_message = "Err: \"default\" tag is a reserved word already and only affected to Stable version."
  }
}

variable "revisiontags_old_stable" {
  description = "The name of the \"revisionTag\" which is bound to the \"old-stable\" Istio revision. This is the previous stable revision you expect to remove when all the workload will be migrated to the new stable revision."
  type        = string
  default     = "old-stable"
  validation {
    condition     = !contains(["default"], lower(var.revisiontags_old_stable))
    error_message = "Err: \"default\" tag is a reserved word which is managed by the module for the Stable revision."
  }
}

variable "revisiontags_canary" {
  description = "The name of the \"revisionTag\" which is bound to the \"canary\" Istio revision. Your app should only reference this revisionTag in case of a canary upgrade."
  type        = string
  default     = "prod-canary"
  validation {
    condition     = !contains(["default"], lower(var.revisiontags_canary))
    error_message = "Err: \"default\" tag is a reserved word which is managed by the module for the Stable revision."
  }
}

variable "istio_istiod_instance" {
  description = <<EOT
  Map of objects used to configure one or more instances of istio-istiod.

  Example: {
    "1-19" = {
      version = "1.19.3"
      revision = "1-19"
      is_default_revision = true
      revisiontags_binding = "stable"
      helm_values = {
        "pilot": {
          "autoscaleEnabled": true,
          "autoscaleMax": 3,
          "autoscaleMin": 2
        },
      }
    },
  }
  EOT
  type        = any
  default     = {}

  validation {
    condition     = anytrue([for instance, instance_config in var.istio_istiod_instance : instance_config["revisiontags_binding"] == "stable"])
    error_message = "Err: You should define at least one stable istiod instance."
  }

  # The next validation rule should never match due to constraint on revisiontags_binding.
  validation {
    condition = length([
    for instance in var.istio_istiod_instance : instance]) <= 2
    error_message = "Err: You cannot create more than two istiod instances."
  }

  validation {
    condition = alltrue([
    for instance in var.istio_istiod_instance : can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", instance.version))])
    error_message = "Err: Version must be defined and a valid semantic version."
  }

  validation {
    condition = alltrue([
    for instance in var.istio_istiod_instance : !can(regex("\\.", instance.revision)) && length(instance.revision) > 0])
    error_message = "Err: Value for revison must be non null and cannot contain a dot(\".\") character."
  }

  validation {
    condition = alltrue([
    for instance in var.istio_istiod_instance : can(tobool(instance.is_default_revision))])
    error_message = "Err: Variable \"is_default_revision\" (boolean) must be set for each Istiod instance."
  }

  validation {
    condition     = length([for instance in var.istio_istiod_instance : instance]) == 1 ? anytrue([for instance in var.istio_istiod_instance : contains([true], instance.is_default_revision)]) : true
    error_message = "Err: If there's only one istiod instance you should set it as the default revision."
  }

  validation {
    condition     = !anytrue([for instance in var.istio_istiod_instance : contains([true], instance.is_default_revision) && contains(["canary", "old-stable"], instance.revisiontags_binding)])
    error_message = "Err: Only the \"stable revision\" can be the \"default revision\"."
  }

  validation {
    condition = alltrue([
    for instance in var.istio_istiod_instance : contains(["canary", "stable", "old-stable"], instance.revisiontags_binding)])
    error_message = "Err: Value for revisiontags_binding should be either \"canary\", \"stable\" or \"old-stable\"."
  }

  validation {
    condition     = length(distinct([for instance, instance_config in var.istio_istiod_instance : instance_config["revisiontags_binding"]])) == length([for instance in var.istio_istiod_instance : instance])
    error_message = "Err: You cannot define more than one stable|old-stable|canary istiod instance."
  }

  validation {
    condition     = length(distinct([for instance, instance_config in var.istio_istiod_instance : instance_config["revision"]])) == length([for instance in var.istio_istiod_instance : instance])
    error_message = "Err: You cannot set the same revision for two istiod instances."
  }

  validation {
    condition = alltrue(flatten([
      for instance, instance_config in var.istio_istiod_instance : [
      for k, v in instance_config.helm_values : !can(regex("^(revision|revisionTags)$", k))]
    ]))
    error_message = "Err: You cannot override \"revision\" and \"revisionTags\" through \"helm_values\". Use \"revision\" and \"revisiontags_binding\" attributes."
  }
}

# istio/istio-ingressgateway
variable "istio_ingressgateway_enabled" {
  description = "Flag to enable or disable the installation of istio-ingressgateway components"
  type        = bool
  default     = false
}

variable "istio_ingressgateway_version" {
  description = "The version of the istio-ingressgateway Helm release"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$", var.istio_ingressgateway_version))
    error_message = "Err: Version must be defined and a valid semantic version."
  }
}

variable "istio_ingressgateway_revision_binding" {
  description = "The binding to either the \"canary\" revisionTag or the \"stable\" revisionTag"
  type        = string
  default     = "stable"

  validation {
    condition     = contains(["canary", "stable"], var.istio_ingressgateway_revision_binding)
    error_message = "Err: Value for revision_binding should be either \"canary\" or \"stable\"."
  }
}

variable "istio_ingressgateway_overlay_helm_values" {
  description = "Any values to pass as an overlay to the istio-ingressgateway Helm values"
  type        = any
  default     = {}

  validation {
    condition = alltrue(flatten([
      for k, v in var.istio_ingressgateway_overlay_helm_values : !can(regex("^(revision)$", k))]
    ))
    error_message = "Err: You cannot override \"revision\" through \"helm_values\". Use \"istio_ingressgateway_revision_binding\" variable."
  }
}

variable "istio_ingressgateway_create_namespace" {
  description = "Flag to enable or disable the creation of the istio-ingressgateway namespace"
  type        = bool
  default     = true
}

variable "istio_ingressgateway_namespace" {
  description = "The name of the istio-ingressgateway namespace"
  type        = string
  default     = "istio-ingress"
}

variable "istio_ingressgateway_backendconfig_name" {
  description = "The name of the istio-ingressgateway BackendConfig (Only if platform is equal to GCP)"
  type        = string
  default     = "istio-ingressgateway"
}

variable "istio_ingressgateway_create_shared_secured_gateway" {
  description = "Flag to enable or disable the creation of the Istio Shared Secured Gateway"
  type        = bool
  default     = true
}

variable "istio_ingressgateway_shared_secured_gateway_name" {
  description = "The name of the istio-ingressgateway of the Istio Shared Secured Gateway"
  type        = string
  default     = "istio-ingressgateway"
}

variable "istio_ingressgateway_shared_secured_gateway_namespace" {
  description = "The name of the istio-ingressgateway/shared-secured-gateway namespace"
  type        = string
  default     = "istio-ingress"
}

#### KIALI ####
variable "kiali_operator_enabled" {
  description = "Flag to enable or disable the installation of kiali-operator components"
  type        = bool
  default     = true
}

variable "kiali_helm_repo" {
  description = "The URL of the Kiali Helm repository"
  type        = string
  default     = "https://kiali.org/helm-charts"
}

variable "kiali_operator_version" {
  description = "The version of the kiali-operator Helm release"
  type        = string
}

variable "kiali_operator_namespace" {
  description = "The name of the kiali-operator namespace"
  type        = string
  default     = "kiali-operator"
}

variable "kiali_operator_overlay_helm_values" {
  description = "Any values to pass as an overlay to the kiali-operator Helm values"
  type        = any
  default     = {}
}

variable "kiali_operator_accessible_namespaces" {
  description = <<EOT
  List of namespaces which are accessible to the Kiali server itself. Only these namespaces will be displayed into the Kiali UI.

  Example: ["istio-system","mycorp_.*"]
  EOT
  type        = list(any)
  default     = []
}

#### JAEGER ####
variable "jaeger_operator_enabled" {
  description = "Flag to enable or disable the installation of jaeger-operator components"
  type        = bool
  default     = true
}

variable "jaeger_helm_repo" {
  description = "The URL of the Jaeger Helm repository"
  type        = string
  default     = "https://jaegertracing.github.io/helm-charts"
}

variable "jaeger_operator_version" {
  description = "The version of jaeger-operator Helm release"
  type        = string
}

variable "jaeger_operator_namespace" {
  description = "The name of the jaeger-operator namespace"
  type        = string
  default     = "observability"
}

variable "jaeger_operator_overlay_helm_values" {
  description = "Any values to pass as an overlay to the jaeger-operator Helm values"
  type        = any
  default     = {}
}

variable "jaeger_operator_create_instance_allinone" {
  description = "Flag to enable or disable the creation of a Jaeger All-in-One instance"
  type        = bool
  default     = true
}

variable "jaeger_operator_instance_allinone_image_version" {
  description = "The version of the Jaeger All-in-One instance image"
  type        = string
  default     = "1.52.0"
}

variable "jaeger_operator_instance_allinone_affinity" {
  description = <<EOT
  Map of objects used to configure affinity rules for the Jaeger All-in-One instance.

  Example:
    {
    "nodeAffinity": {
      "requiredDuringSchedulingIgnoredDuringExecution": {
        "nodeSelectorTerms": [
          {
            "matchExpressions": [
              {
                "key": "kubernetes.io/os",
                "operator": "In",
                "values": [
                  "linux"
                ]
              }
            ]
          }
        ]
      }
    },
  }
  EOT
  type        = map(any)
  default     = {}
}

#### CERT-MANAGER ####
variable "cert_manager_enabled" {
  description = "Flag to enable or disable the installation of cert-manager components"
  type        = bool
  default     = true
}

variable "cert_manager_helm_repo" {
  description = "The URL of the cert-manager Helm repository"
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "cert_manager_version" {
  description = "The version of the cert-manager Helm release"
  type        = string
  default     = ""
}

variable "cert_manager_namespace" {
  description = "The name of the cert-manager namespace"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_overlay_helm_values" {
  description = "Any values to pass as an overlay to the cert-manager Helm values"
  type        = any
  default     = {}
}

#### KUBE-PROMETHEUS-STACK ####
variable "kube_prometheus_stack_enabled" {
  description = "Flag to enable or disable the installation of the kube-prometheus-stack components"
  type        = bool
  default     = true
}

variable "kube_prometheus_stack_helm_repo" {
  description = "The URL of the kube-prometheus-stack Helm repository"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "kube_prometheus_stack_version" {
  description = "The version of the kube-prometheus-stack Helm release"
  type        = string
  default     = ""
}

variable "kube_prometheus_stack_namespace" {
  description = "The name of the kube-prometheus-stack namespace"
  type        = string
  default     = "monitoring"
}

variable "kube_prometheus_stack_overlay_helm_values" {
  description = "Any values to pass as an overlay to the kube-prometheus-stack Helm values"
  type        = any
  default     = {}
}
