# Deploy the istio-oss-stack for the first time.

Here is an example of an initial configuration :

```
module "istio-oss-stack" {
  source = "git::git@github.com:blackpegaz/terraform-istio-oss-stack.git"

  # Global
  domain = "example.com"


  # Istio 
  
  istio_enabled = true
  /* istio_platform = "gcp" */
  
  istio_istiod_overlay_helm_values = {}

  istio_istiod_instance = {
    "1-19" = {
      version = "1.19.3"
      revision = "1-19"
      is_default_revision = true
      revisiontags_binding = "stable"
      helm_values = {}
    },
  }

  # Ingress Gateways

  ## istio-ingressgateway
  istio_ingressgateway_enabled = true
  istio_ingressgateway_version = "1.19.3"
  istio_ingressgateway_revision_binding = "stable"
  istio_ingressgateway_overlay_helm_values = {}

  istio_ingressgateway_create_shared_secured_gateway = false
   
  # Integrations / Addons

  ## kiali (Observability and Management UI for Istio Service Mesh)
  kiali_operator_enabled = true
  kiali_operator_version = "1.77.0"
  kiali_operator_accessible_namespaces = ["istio-system","demo.*"]
  kiali_operator_overlay_helm_values = {}

  ## jaeger (tracing)
  jaeger_operator_enabled = true
  jaeger_operator_version = "2.49.0"
  jaeger_operator_overlay_helm_values = {}

  ## kube-prometheus-stack (monitoring)
  kube_prometheus_stack_enabled = true
  kube_prometheus_stack_version = "55.5.0"

  # Dependencies
  
  ## cert-manager (currently required by the Jaeger Operator)
  cert_manager_enabled = true
  cert_manager_version = "v1.13.3"
  cert_manager_overlay_helm_values = {}
}
```

## Checks
**Automated**
- `version` should be a semantic version.
- `revisiontags_binding` should be defined.
- `revisiontags_binding` should be `stable` if there is no existing instance.
- `is_default_revision` must be defined.
- `is_default_revision` must be `stable` if there is only one version.
- `revision` value cannot contain a dot.

## Progress report

**Deployed Helm releases** :
```
helm list --all-namespaces

NAME                    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                           APP VERSION
cert-manager            cert-manager    1               2024-01-20 14:06:07.408161914 +0100 CET deployed        cert-manager-v1.13.3            v1.13.3
istio-base              istio-system    1               2024-01-20 14:06:05.064777144 +0100 CET deployed        base-1.19.3                     1.19.3
istio-cni               kube-system     1               2024-01-20 14:06:09.895242416 +0100 CET deployed        cni-1.19.3                      1.19.3
istio-ingressgateway    istio-ingress   1               2024-01-20 14:06:49.429322562 +0100 CET deployed        gateway-1.19.3                  1.19.3
istio-istiod-1-19       istio-system    1               2024-01-20 14:06:12.206712011 +0100 CET deployed        istiod-1.19.3                   1.19.3
jaeger-operator         observability   1               2024-01-20 14:06:50.878055335 +0100 CET deployed        jaeger-operator-2.49.0          1.49.0
kiali-operator          kiali-operator  1               2024-01-20 14:07:08.250486317 +0100 CET deployed        kiali-operator-1.77.0           v1.77.0
kube-prometheus-stack   monitoring      1               2024-01-20 14:06:10.072777066 +0100 CET deployed        kube-prometheus-stack-55.5.0    v0.70.0
```

**Existing revision tags** :
```
istioctl tag list

TAG         REVISION NAMESPACES
default     1-19
prod-stable 1-19
```


**Terraform outputs** :
```
terraform console

> module.istio-oss-stack
{
  "istio" = {
    "canary_revision" = ""
    "canary_version" = ""
    "default_revision" = "1-19"
    "ingressgateway_revision" = "prod-stable"
    "ingressgateway_version" = "1.19.3"
    "old_stable_revision" = ""
    "old_stable_version" = ""
    "stable_revision" = "1-19"
    "stable_version" = "1.19.3"
  }
}
