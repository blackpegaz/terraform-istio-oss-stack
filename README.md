<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.24.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.0.4 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingressgateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.jaeger](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kiali_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.base_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.istio_ingressgateway_backendconfig](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.cert_manager_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.istio_base_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.istio_ingressgateway_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.jaeger_operator_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.kiali_operator_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [helm_template.base_crds](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/data-sources/template) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | enable helm install of cert-manager | `bool` | `true` | no |
| <a name="input_cert_manager_helm_repo"></a> [cert\_manager\_helm\_repo](#input\_cert\_manager\_helm\_repo) | cert-manager helm repository | `string` | `"https://charts.jetstack.io"` | no |
| <a name="input_cert_manager_helm_values"></a> [cert\_manager\_helm\_values](#input\_cert\_manager\_helm\_values) | kiali operator helm values | `any` | `{}` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | cert-manager namespace | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | cert-manager version | `string` | `"v1.13.3"` | no |
| <a name="input_istio_base_common_helm_values"></a> [istio\_base\_common\_helm\_values](#input\_istio\_base\_common\_helm\_values) | istiod common helm values | `any` | `{}` | no |
| <a name="input_istio_base_crds_version"></a> [istio\_base\_crds\_version](#input\_istio\_base\_crds\_version) | base crds version | `string` | `""` | no |
| <a name="input_istio_base_enabled"></a> [istio\_base\_enabled](#input\_istio\_base\_enabled) | enable helm install of istio base | `bool` | `true` | no |
| <a name="input_istio_base_namespace"></a> [istio\_base\_namespace](#input\_istio\_base\_namespace) | istio base namespace | `string` | `"istio-system"` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | istio\_base\_version | `string` | `""` | no |
| <a name="input_istio_cni_enabled"></a> [istio\_cni\_enabled](#input\_istio\_cni\_enabled) | enable helm install of istio cni | `bool` | `false` | no |
| <a name="input_istio_cni_namespace"></a> [istio\_cni\_namespace](#input\_istio\_cni\_namespace) | istio cni namespace | `string` | `"kube-system"` | no |
| <a name="input_istio_cni_version"></a> [istio\_cni\_version](#input\_istio\_cni\_version) | istio\_cni\_version | `string` | `""` | no |
| <a name="input_istio_enabled"></a> [istio\_enabled](#input\_istio\_enabled) | enable istio | `bool` | `true` | no |
| <a name="input_istio_helm_repo"></a> [istio\_helm\_repo](#input\_istio\_helm\_repo) | istio helm repository | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_istio_ingressgateway_common_helm_values"></a> [istio\_ingressgateway\_common\_helm\_values](#input\_istio\_ingressgateway\_common\_helm\_values) | istio ingressgateway common helm values | `any` | `{}` | no |
| <a name="input_istio_ingressgateway_create_namespace"></a> [istio\_ingressgateway\_create\_namespace](#input\_istio\_ingressgateway\_create\_namespace) | enable helm install of istio ingressgateway | `bool` | `true` | no |
| <a name="input_istio_ingressgateway_enabled"></a> [istio\_ingressgateway\_enabled](#input\_istio\_ingressgateway\_enabled) | enable helm install of istio ingressgateway | `bool` | `false` | no |
| <a name="input_istio_ingressgateway_instance"></a> [istio\_ingressgateway\_instance](#input\_istio\_ingressgateway\_instance) | The istio-ingressgateway instance to create | `any` | `{}` | no |
| <a name="input_istio_ingressgateway_namespace"></a> [istio\_ingressgateway\_namespace](#input\_istio\_ingressgateway\_namespace) | istio ingressgateway namespace | `string` | `"istio-ingress"` | no |
| <a name="input_istio_istiod_common_helm_values"></a> [istio\_istiod\_common\_helm\_values](#input\_istio\_istiod\_common\_helm\_values) | istiod common helm values | `any` | `{}` | no |
| <a name="input_istio_istiod_enabled"></a> [istio\_istiod\_enabled](#input\_istio\_istiod\_enabled) | enable helm install of istio istiod | `bool` | `true` | no |
| <a name="input_istio_istiod_instance"></a> [istio\_istiod\_instance](#input\_istio\_istiod\_instance) | The istiod instance to create | `any` | `{}` | no |
| <a name="input_istio_istiod_namespace"></a> [istio\_istiod\_namespace](#input\_istio\_istiod\_namespace) | istio istiod namespace | `string` | `"istio-system"` | no |
| <a name="input_istio_platform"></a> [istio\_platform](#input\_istio\_platform) | (Optional) Platform where Istio is deployed. Possible values are: "openshift", "gcp", "".<br>  An empty value means it is a vanilla Kubernetes distribution, therefore no special treatment will be considered.<br><br>  Default: "" | `string` | `""` | no |
| <a name="input_jaeger_helm_repo"></a> [jaeger\_helm\_repo](#input\_jaeger\_helm\_repo) | jaeger helm repository | `string` | `"https://jaegertracing.github.io/helm-charts"` | no |
| <a name="input_jaeger_operator_enabled"></a> [jaeger\_operator\_enabled](#input\_jaeger\_operator\_enabled) | enable helm install of jaeger | `bool` | `true` | no |
| <a name="input_jaeger_operator_helm_values"></a> [jaeger\_operator\_helm\_values](#input\_jaeger\_operator\_helm\_values) | kiali operator helm values | `any` | `{}` | no |
| <a name="input_jaeger_operator_namespace"></a> [jaeger\_operator\_namespace](#input\_jaeger\_operator\_namespace) | jaeger operator namespace | `string` | `"observability"` | no |
| <a name="input_jaeger_operator_version"></a> [jaeger\_operator\_version](#input\_jaeger\_operator\_version) | jaeger operator version | `string` | n/a | yes |
| <a name="input_kiali_helm_repo"></a> [kiali\_helm\_repo](#input\_kiali\_helm\_repo) | kiali helm repository | `string` | `"https://kiali.org/helm-charts"` | no |
| <a name="input_kiali_operator_enabled"></a> [kiali\_operator\_enabled](#input\_kiali\_operator\_enabled) | enable helm install of kiali operator | `bool` | `true` | no |
| <a name="input_kiali_operator_helm_values"></a> [kiali\_operator\_helm\_values](#input\_kiali\_operator\_helm\_values) | kiali operator helm values | `any` | `{}` | no |
| <a name="input_kiali_operator_namespace"></a> [kiali\_operator\_namespace](#input\_kiali\_operator\_namespace) | kiali operator namespace | `string` | `"kiali-operator"` | no |
| <a name="input_kiali_operator_version"></a> [kiali\_operator\_version](#input\_kiali\_operator\_version) | kiali operator version | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_istio_base_helm_metadata"></a> [istio\_base\_helm\_metadata](#output\_istio\_base\_helm\_metadata) | block status of the istio base helm release |
| <a name="output_istio_cni_helm_metadata"></a> [istio\_cni\_helm\_metadata](#output\_istio\_cni\_helm\_metadata) | block status of the istio cni helm release |
<!-- END_TF_DOCS -->
