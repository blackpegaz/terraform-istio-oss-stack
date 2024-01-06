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

variable "prometheus_in_cluster_url" {
  description = "prometheus in cluster url"
  type        = string
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

variable "istio_stable_revision" {
  description = "istio stable revision" # FIXME
  type        = string
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

variable "istio_istiod_instance" {
  description = <<EOT
  Map of objects used to configure one or more instances of istio-istiod.

  Example: {
    "1-19" = {
      version = "1.19.3"
      helm_values = {
        "revision": "1-19",
        "revisionTags": ["default","prod-stable"] 
      }
    },
  }
  EOT
  type        = any
  default     = {}
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


variable "istio_ingressgateway_overlay_helm_values" {
  description = "Any values to pass as an overlay to the istio-ingressgateway Helm values"
  type        = any
  default     = {}
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
  description = "Flag to enable or disable the installation of kube-prometheus-stack-components"
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
