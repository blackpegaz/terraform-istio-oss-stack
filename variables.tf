### Global ###
variable "domain" {
  description = "domain used to configure external urls"
  type        = string
}

variable "istio_oss_stack_default_nodeselector" {
  description = "istio oss stack default nodeselector"
  type        = map(any)
  default     = {}
}

variable "prometheus_in_cluster_url" {
  description = "prometheus in cluster url"
  type        = string
}

#### ISTIO #### 
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

variable "istio_stable_revision" {
  description = "istio stable revision"
  type        = string
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

variable "istio_base_overlay_helm_values" {
  description = "istio base overlay helm values"
  type        = any
  default     = {}
}

# istio/cni
variable "istio_cni_enabled" {
  description = "enable helm install of istio cni"
  type        = bool
  default     = true
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

variable "istio_cni_overlay_helm_values" {
  description = "istio cni overlay helm values"
  type        = any
  default     = {}
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

variable "istio_istiod_overlay_helm_values" {
  description = "istio istiod overlay helm values"
  type        = any
  default     = {}
}

variable "istio_istiod_instance" {
  description = "The istiod instance to create"
  type        = any
  default     = {}
}

# istio/istio-ingressgateway
variable "istio_ingressgateway_enabled" {
  description = "enable helm install of istio ingressgateway"
  type        = bool
  default     = false
}

variable "istio_ingressgateway_version" {
  description = "istio_ingressgateway_version"
  type        = string
  default     = ""
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

variable "istio_ingressgateway_backendconfig_name" {
  description = "istio ingressgateway backendconfig name"
  type        = string
  default     = "istio-ingressgateway"
}


variable "istio_ingressgateway_overlay_helm_values" {
  description = "istio ingressgateway common helm values"
  type        = any
  default     = {}
}

variable "istio_ingressgateway_create_shared_secured_gateway" {
  description = "istio ingressgateway backendconfig name"
  type        = bool
  default     = true
}

variable "istio_ingressgateway_shared_secured_gateway_name" {
  description = "istio ingressgateway shared secured gateway name"
  type        = string
  default     = "istio-ingressgateway"
}

variable "istio_ingressgateway_shared_secured_gateway_namespace" {
  description = "istio ingressgateway shared secured gateway name"
  type        = string
  default     = "istio-ingress"
}

#### KIALI ####
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

variable "kiali_operator_overlay_helm_values" {
  description = "kiali operator helm values"
  type        = any
  default     = {}
}

variable "kiali_operator_accessible_namespaces" {
  description = "kiali operator accessible namespaces"
  type        = list(any)
  default     = []
}

#### JAEGER ####
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

variable "jaeger_operator_overlay_helm_values" {
  description = "jaeger operator helm values"
  type        = any
  default     = {}
}

variable "jaeger_operator_create_instance_allinone" {
  description = "jaeger operator create instance allinone"
  type        = bool
  default     = true
}

variable "jaeger_operator_instance_allinone_image_version" {
  description = "jaeger operator instance allinone image version"
  type        = string
  default     = "1.52.0"
}

#### CERT-MANAGER ####
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
  default     = ""
}

variable "cert_manager_namespace" {
  description = "cert-manager namespace"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_overlay_helm_values" {
  description = "kiali operator helm values"
  type        = any
  default     = {}
}

#### KUBE-PROMETHEUS-STACK ####
variable "kube_prometheus_stack_enabled" {
  description = "kube prometheus stack enabled"
  type        = bool
  default     = true
}

variable "kube_prometheus_stack_helm_repo" {
  description = "kube prometheus stack helm repository"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "kube_prometheus_stack_version" {
  description = "kube prometheus stack version"
  type        = string
  default     = ""
}

variable "kube_prometheus_stack_namespace" {
  description = "kube prometheus stack namespace"
  type        = string
  default     = "monitoring"
}

variable "kube_prometheus_stack_overlay_helm_values" {
  description = "kube prometheus stack overlay helm values"
  type        = any
  default     = {}
}
