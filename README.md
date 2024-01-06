<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 2.0.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 2.0.4 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingressgateway](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_istiod](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.jaeger_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kiali_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kube_prometheus_stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.base_crd_crdallgen](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.base_crd_operator](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.cert_manager_crd_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.istio_ingressgateway_backendconfig](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.istio_ingressgateway_shared_secured_gateway](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.jaeger_operator_crd_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.jaeger_operator_instance_allinone](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.kiali_operator_crd_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.cert_manager_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.istio_base_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.istio_ingressgateway_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.jaeger_operator_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.kiali_operator_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.kube_prometheus_stack_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/namespace_v1) | resource |
| [http_http.base_crd_crdallgen](https://registry.terraform.io/providers/hashicorp/http/3.4.1/docs/data-sources/http) | data source |
| [http_http.base_crd_operator](https://registry.terraform.io/providers/hashicorp/http/3.4.1/docs/data-sources/http) | data source |
| [http_http.cert_manager_crd_crds](https://registry.terraform.io/providers/hashicorp/http/3.4.1/docs/data-sources/http) | data source |
| [http_http.jaeger_operator_crd_crds](https://registry.terraform.io/providers/hashicorp/http/3.4.1/docs/data-sources/http) | data source |
| [http_http.kiali_operator_crd_crds](https://registry.terraform.io/providers/hashicorp/http/3.4.1/docs/data-sources/http) | data source |
| [kubectl_file_documents.base_crd_crdallgen](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.base_crd_operator](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.cert_manager_crd_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.jaeger_operator_crd_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/data-sources/file_documents) | data source |
| [kubectl_file_documents.kiali_operator_crd_crds](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/data-sources/file_documents) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Flag to enable or disable the installation of cert-manager components | `bool` | `true` | no |
| <a name="input_cert_manager_helm_repo"></a> [cert\_manager\_helm\_repo](#input\_cert\_manager\_helm\_repo) | The URL of the cert-manager Helm repository | `string` | `"https://charts.jetstack.io"` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | The name of the cert-manager namespace | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_overlay_helm_values"></a> [cert\_manager\_overlay\_helm\_values](#input\_cert\_manager\_overlay\_helm\_values) | Any values to pass as an overlay to the cert-manager Helm values | `any` | `{}` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | The version of the cert-manager Helm release | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The FQDN used to configure external urls"<br><br>  Example: "example.com" | `string` | n/a | yes |
| <a name="input_istio_base_crds_version"></a> [istio\_base\_crds\_version](#input\_istio\_base\_crds\_version) | The version of the istio-base CRDs | `string` | `""` | no |
| <a name="input_istio_base_enabled"></a> [istio\_base\_enabled](#input\_istio\_base\_enabled) | Flag to enable or disable the installation of istio-base components | `bool` | `true` | no |
| <a name="input_istio_base_namespace"></a> [istio\_base\_namespace](#input\_istio\_base\_namespace) | The name of the istio-base namespace | `string` | `"istio-system"` | no |
| <a name="input_istio_base_overlay_helm_values"></a> [istio\_base\_overlay\_helm\_values](#input\_istio\_base\_overlay\_helm\_values) | Any values to pass as an overlay to the istio-base Helm values | `any` | `{}` | no |
| <a name="input_istio_base_version"></a> [istio\_base\_version](#input\_istio\_base\_version) | The version of the istio-base Helm release | `string` | `""` | no |
| <a name="input_istio_cni_enabled"></a> [istio\_cni\_enabled](#input\_istio\_cni\_enabled) | Flag to enable or disable the installation of istio-cni components | `bool` | `true` | no |
| <a name="input_istio_cni_namespace"></a> [istio\_cni\_namespace](#input\_istio\_cni\_namespace) | The name of the istio-cni namespace | `string` | `"kube-system"` | no |
| <a name="input_istio_cni_overlay_helm_values"></a> [istio\_cni\_overlay\_helm\_values](#input\_istio\_cni\_overlay\_helm\_values) | Any values to pass as an overlay to the istio-cni Helm values | `any` | `{}` | no |
| <a name="input_istio_cni_version"></a> [istio\_cni\_version](#input\_istio\_cni\_version) | The version of the istio-cni Helm release | `string` | `""` | no |
| <a name="input_istio_enabled"></a> [istio\_enabled](#input\_istio\_enabled) | Flag to enable or disable the installation of all istio components | `bool` | `true` | no |
| <a name="input_istio_helm_repo"></a> [istio\_helm\_repo](#input\_istio\_helm\_repo) | The URL of the Istio Helm repository | `string` | `"https://istio-release.storage.googleapis.com/charts"` | no |
| <a name="input_istio_ingressgateway_backendconfig_name"></a> [istio\_ingressgateway\_backendconfig\_name](#input\_istio\_ingressgateway\_backendconfig\_name) | The name of the istio-ingressgateway BackendConfig (Only if platform is equal to GCP) | `string` | `"istio-ingressgateway"` | no |
| <a name="input_istio_ingressgateway_create_namespace"></a> [istio\_ingressgateway\_create\_namespace](#input\_istio\_ingressgateway\_create\_namespace) | Flag to enable or disable the creation of the istio-ingressgateway namespace | `bool` | `true` | no |
| <a name="input_istio_ingressgateway_create_shared_secured_gateway"></a> [istio\_ingressgateway\_create\_shared\_secured\_gateway](#input\_istio\_ingressgateway\_create\_shared\_secured\_gateway) | Flag to enable or disable the creation of the Istio Shared Secured Gateway | `bool` | `true` | no |
| <a name="input_istio_ingressgateway_enabled"></a> [istio\_ingressgateway\_enabled](#input\_istio\_ingressgateway\_enabled) | Flag to enable or disable the installation of istio-ingressgateway components | `bool` | `false` | no |
| <a name="input_istio_ingressgateway_namespace"></a> [istio\_ingressgateway\_namespace](#input\_istio\_ingressgateway\_namespace) | The name of the istio-ingressgateway namespace | `string` | `"istio-ingress"` | no |
| <a name="input_istio_ingressgateway_overlay_helm_values"></a> [istio\_ingressgateway\_overlay\_helm\_values](#input\_istio\_ingressgateway\_overlay\_helm\_values) | Any values to pass as an overlay to the istio-ingressgateway Helm values | `any` | `{}` | no |
| <a name="input_istio_ingressgateway_shared_secured_gateway_name"></a> [istio\_ingressgateway\_shared\_secured\_gateway\_name](#input\_istio\_ingressgateway\_shared\_secured\_gateway\_name) | The name of the istio-ingressgateway of the Istio Shared Secured Gateway | `string` | `"istio-ingressgateway"` | no |
| <a name="input_istio_ingressgateway_shared_secured_gateway_namespace"></a> [istio\_ingressgateway\_shared\_secured\_gateway\_namespace](#input\_istio\_ingressgateway\_shared\_secured\_gateway\_namespace) | The name of the istio-ingressgateway/shared-secured-gateway namespace | `string` | `"istio-ingress"` | no |
| <a name="input_istio_ingressgateway_version"></a> [istio\_ingressgateway\_version](#input\_istio\_ingressgateway\_version) | The version of the istio-ingressgateway Helm release | `string` | `""` | no |
| <a name="input_istio_istiod_enabled"></a> [istio\_istiod\_enabled](#input\_istio\_istiod\_enabled) | Flag to enable or disable the installation of istio-istiod components | `bool` | `true` | no |
| <a name="input_istio_istiod_instance"></a> [istio\_istiod\_instance](#input\_istio\_istiod\_instance) | Map of objects used to configure one or more instances of istio-istiod.<br><br>  Example: {<br>    "1-19" = {<br>      version = "1.19.3"<br>      helm\_values = {<br>        "revision": "1-19",<br>        "revisionTags": ["default","prod-stable"] <br>      }<br>    },<br>  } | `any` | `{}` | no |
| <a name="input_istio_istiod_namespace"></a> [istio\_istiod\_namespace](#input\_istio\_istiod\_namespace) | The name of the istio-istiod namespace | `string` | `"istio-system"` | no |
| <a name="input_istio_istiod_overlay_helm_values"></a> [istio\_istiod\_overlay\_helm\_values](#input\_istio\_istiod\_overlay\_helm\_values) | Any values to pass as an overlay to the istio-istiod Helm values | `any` | `{}` | no |
| <a name="input_istio_oss_stack_default_nodeselector"></a> [istio\_oss\_stack\_default\_nodeselector](#input\_istio\_oss\_stack\_default\_nodeselector) | Map of key/value pairs used to configure nodeSelector for the entire stack.<br><br>  Example: {"disktype":"ssd"}<br>  } | `map(any)` | `{}` | no |
| <a name="input_istio_platform"></a> [istio\_platform](#input\_istio\_platform) | (Optional) Platform where Istio is deployed. Possible values are: "openshift", "gcp", "".<br>  An empty value means it is a vanilla Kubernetes distribution, therefore no special treatment will be considered.<br><br>  Default: "" | `string` | `""` | no |
| <a name="input_istio_stable_revision"></a> [istio\_stable\_revision](#input\_istio\_stable\_revision) | istio stable revision | `string` | n/a | yes |
| <a name="input_jaeger_helm_repo"></a> [jaeger\_helm\_repo](#input\_jaeger\_helm\_repo) | The URL of the Jaeger Helm repository | `string` | `"https://jaegertracing.github.io/helm-charts"` | no |
| <a name="input_jaeger_operator_create_instance_allinone"></a> [jaeger\_operator\_create\_instance\_allinone](#input\_jaeger\_operator\_create\_instance\_allinone) | Flag to enable or disable the creation of a Jaeger All-in-One instance | `bool` | `true` | no |
| <a name="input_jaeger_operator_enabled"></a> [jaeger\_operator\_enabled](#input\_jaeger\_operator\_enabled) | Flag to enable or disable the installation of jaeger-operator components | `bool` | `true` | no |
| <a name="input_jaeger_operator_instance_allinone_affinity"></a> [jaeger\_operator\_instance\_allinone\_affinity](#input\_jaeger\_operator\_instance\_allinone\_affinity) | Map of objects used to configure affinity rules for the Jaeger All-in-One instance.<br><br>  Example:<br>    {<br>    "nodeAffinity": {<br>      "requiredDuringSchedulingIgnoredDuringExecution": {<br>        "nodeSelectorTerms": [<br>          {<br>            "matchExpressions": [<br>              {<br>                "key": "kubernetes.io/os",<br>                "operator": "In",<br>                "values": [<br>                  "linux"<br>                ]<br>              }<br>            ]<br>          }<br>        ]<br>      }<br>    },<br>  } | `map(any)` | `{}` | no |
| <a name="input_jaeger_operator_instance_allinone_image_version"></a> [jaeger\_operator\_instance\_allinone\_image\_version](#input\_jaeger\_operator\_instance\_allinone\_image\_version) | The version of the Jaeger All-in-One instance image | `string` | `"1.52.0"` | no |
| <a name="input_jaeger_operator_namespace"></a> [jaeger\_operator\_namespace](#input\_jaeger\_operator\_namespace) | The name of the jaeger-operator namespace | `string` | `"observability"` | no |
| <a name="input_jaeger_operator_overlay_helm_values"></a> [jaeger\_operator\_overlay\_helm\_values](#input\_jaeger\_operator\_overlay\_helm\_values) | Any values to pass as an overlay to the jaeger-operator Helm values | `any` | `{}` | no |
| <a name="input_jaeger_operator_version"></a> [jaeger\_operator\_version](#input\_jaeger\_operator\_version) | The version of jaeger-operator Helm release | `string` | n/a | yes |
| <a name="input_kiali_helm_repo"></a> [kiali\_helm\_repo](#input\_kiali\_helm\_repo) | The URL of the Kiali Helm repository | `string` | `"https://kiali.org/helm-charts"` | no |
| <a name="input_kiali_operator_accessible_namespaces"></a> [kiali\_operator\_accessible\_namespaces](#input\_kiali\_operator\_accessible\_namespaces) | List of namespaces which are accessible to the Kiali server itself. Only these namespaces will be displayed into the Kiali UI.<br><br>  Example: ["istio-system","mycorp\_.*"] | `list(any)` | `[]` | no |
| <a name="input_kiali_operator_enabled"></a> [kiali\_operator\_enabled](#input\_kiali\_operator\_enabled) | Flag to enable or disable the installation of kiali-operator components | `bool` | `true` | no |
| <a name="input_kiali_operator_namespace"></a> [kiali\_operator\_namespace](#input\_kiali\_operator\_namespace) | The name of the kiali-operator namespace | `string` | `"kiali-operator"` | no |
| <a name="input_kiali_operator_overlay_helm_values"></a> [kiali\_operator\_overlay\_helm\_values](#input\_kiali\_operator\_overlay\_helm\_values) | Any values to pass as an overlay to the kiali-operator Helm values | `any` | `{}` | no |
| <a name="input_kiali_operator_version"></a> [kiali\_operator\_version](#input\_kiali\_operator\_version) | The version of the kiali-operator Helm release | `string` | n/a | yes |
| <a name="input_kube_prometheus_stack_enabled"></a> [kube\_prometheus\_stack\_enabled](#input\_kube\_prometheus\_stack\_enabled) | Flag to enable or disable the installation of kube-prometheus-stack-components | `bool` | `true` | no |
| <a name="input_kube_prometheus_stack_helm_repo"></a> [kube\_prometheus\_stack\_helm\_repo](#input\_kube\_prometheus\_stack\_helm\_repo) | The URL of the kube-prometheus-stack Helm repository | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_kube_prometheus_stack_namespace"></a> [kube\_prometheus\_stack\_namespace](#input\_kube\_prometheus\_stack\_namespace) | The name of the kube-prometheus-stack namespace | `string` | `"monitoring"` | no |
| <a name="input_kube_prometheus_stack_overlay_helm_values"></a> [kube\_prometheus\_stack\_overlay\_helm\_values](#input\_kube\_prometheus\_stack\_overlay\_helm\_values) | Any values to pass as an overlay to the kube-prometheus-stack Helm values | `any` | `{}` | no |
| <a name="input_kube_prometheus_stack_version"></a> [kube\_prometheus\_stack\_version](#input\_kube\_prometheus\_stack\_version) | The version of the kube-prometheus-stack Helm release | `string` | `""` | no |
| <a name="input_prometheus_in_cluster_url"></a> [prometheus\_in\_cluster\_url](#input\_prometheus\_in\_cluster\_url) | prometheus in cluster url | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_istio_base_helm_metadata"></a> [istio\_base\_helm\_metadata](#output\_istio\_base\_helm\_metadata) | block status of the istio base helm release |
| <a name="output_istio_cni_helm_metadata"></a> [istio\_cni\_helm\_metadata](#output\_istio\_cni\_helm\_metadata) | block status of the istio cni helm release |
| <a name="output_istio_ingressgateway_helm_metadata"></a> [istio\_ingressgateway\_helm\_metadata](#output\_istio\_ingressgateway\_helm\_metadata) | block status of the istio gateway helm release |
<!-- END_TF_DOCS -->
