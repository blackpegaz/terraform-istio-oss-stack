##### ISTIO ##### 

# istio

variable "istio_enabled" {
  description = "enable istio"
  type        = bool
  default     = true
}

variable "istio_helm_repo" {
  description = "istio helm repository"
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
  description = "enable helm install of istio base"
  type        = bool
  default     = true
}

variable "istio_base_namespace" {
  description = "istio base namespace"
  type        = string
  default     = "istio-system"
}

variable "istio_base_common_helm_values" {
  description = "istiod common helm values"
  type        = any
  default     = {}
}

variable "istio_base_crds_version" {
  description = "base crds version"
  type        = string
  default     = ""
}

variable "istio_base_version" {
  description = "istio_base_version"
  type        = string
  default     = ""
}

# istio/cni
variable "istio_cni_enabled" {
  description = "enable helm install of istio cni"
  type        = bool
  default     = false
}

variable "istio_cni_version" {
  description = "istio_cni_version"
  type        = string
  default     = ""
}

variable "istio_cni_namespace" {
  description = "istio cni namespace"
  type        = string
  default     = "kube-system"
}

# istio/istiod
variable "istio_istiod_enabled" {
  description = "enable helm install of istio istiod"
  type        = bool
  default     = true
}

variable "istio_istiod_namespace" {
  description = "istio istiod namespace"
  type        = string
  default     = "istio-system"
}

variable "istio_istiod_common_helm_values" {
  description = "istiod common helm values"
  type        = any
  default     = {}
}

variable "istio_istiod_instance" {
  description = "The istiod instance to create"
  type        = any # FIXME
  default     = {}
}

# istio/istio-ingressgateway
variable "istio_ingressgateway_enabled" {
  description = "enable helm install of istio ingressgateway"
  type        = bool
  default     = false
}

variable "istio_ingressgateway_create_namespace" {
  description = "enable helm install of istio ingressgateway"
  type        = bool
  default     = true
}

variable "istio_ingressgateway_namespace" {
  description = "istio ingressgateway namespace"
  type        = string
  default     = "istio-ingress"
}

variable "istio_ingressgateway_common_helm_values" {
  description = "istio ingressgateway common helm values"
  type        = any
  default     = {}
}

variable "istio_ingressgateway_instance" {
  description = "The istio-ingressgateway instance to create"
  type        = any # FIXME
  default     = {}
}

##### KIALI #####

variable "kiali_operator_enabled" {
  description = "enable helm install of kiali operator"
  type        = bool
  default     = true
}

variable "kiali_helm_repo" {
  description = "kiali helm repository"
  type        = string
  default     = "https://kiali.org/helm-charts"
}

variable "kiali_operator_version" {
  description = "kiali operator version"
  type        = string
}

variable "kiali_operator_namespace" {
  description = "kiali operator namespace"
  type        = string
  default     = "kiali-operator"
}

variable "kiali_operator_helm_values" {
  description = "kiali operator helm values"
  type        = any
  default     = {}
}

##### JAEGER #####
variable "jaeger_operator_enabled" {
  description = "enable helm install of jaeger"
  type        = bool
  default     = true
}

variable "jaeger_helm_repo" {
  description = "jaeger helm repository"
  type        = string
  default     = "https://jaegertracing.github.io/helm-charts"
}

variable "jaeger_operator_version" {
  description = "jaeger operator version"
  type        = string
}

variable "jaeger_operator_namespace" {
  description = "jaeger operator namespace"
  type        = string
  default     = "observability"
}

variable "jaeger_operator_helm_values" {
  description = "kiali operator helm values"
  type        = any
  default     = {}
}

##### CERT-MANAGER #####
variable "cert_manager_enabled" {
  description = "enable helm install of cert-manager"
  type        = bool
  default     = true
}

variable "cert_manager_helm_repo" {
  description = "cert-manager helm repository"
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "cert_manager_version" {
  description = "cert-manager version"
  type        = string
  default     = "v1.13.3"
}

variable "cert_manager_namespace" {
  description = "cert-manager namespace"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_helm_values" {
  description = "kiali operator helm values"
  type        = any
  default     = {}
}
