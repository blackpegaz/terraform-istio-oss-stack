# 05 - Remove an old instance.

Starting point : 

```
istio_istiod_instance = {
    "1-19" = {
      version = "1.19.4"
      revision = "1-19"
      is_default_revision = false
      revisiontags_binding = "old-stable"
      helm_values = {}
    },
    "1-20" = {
      version = "1.20.1"
      revision = "1-20"
      is_default_revision = true
      revisiontags_binding = "stable"
      helm_values = {}
    },
  }
```

```
helm list --all-namespaces | grep istio
istio-base              istio-system    3               2024-01-24 18:39:12.165734323 +0100 CET deployed        base-1.20.1                     1.20.1     
istio-cni               kube-system     3               2024-01-24 18:39:14.461434206 +0100 CET deployed        cni-1.20.1                      1.20.1     
istio-ingressgateway    istio-ingress   3               2024-01-22 16:35:38.442516623 +0100 CET deployed        gateway-1.20.1                  1.20.1     
istio-istiod-1-19       istio-system    4               2024-01-24 18:39:17.367031482 +0100 CET deployed        istiod-1.19.4                   1.19.4     
istio-istiod-1-20       istio-system    2               2024-01-24 18:57:28.233316698 +0100 CET deployed        istiod-1.20.1                   1.20.1 
```

```
istioctl tag list
TAG         REVISION NAMESPACES
default     1-20     
old-stable  1-19     
prod-stable 1-20     demo
```

```
terraform console     
> module.istio-oss-stack
{
  "istio" = {
    "canary_revision" = ""
    "canary_version" = ""
    "default_revision" = "1-20"
    "ingressgateway_revision" = "prod-stable"
    "ingressgateway_version" = "1.20.1"
    "old_stable_revision" = "1-19"
    "old_stable_version" = "1.19.4"
    "stable_revision" = "1-20"
    "stable_version" = "1.20.1"
  }
}
```

## Instructions

### 1. Remove an `old-stable` istiod_instance.

Here, we remove the `old-stable` istiod_instance, the one with the `revision` equal to `1-19`.

Before : 
```
istio_istiod_instance = {
    "1-19" = {
      version = "1.19.4"
      revision = "1-19"
      is_default_revision = false
      revisiontags_binding = "old-stable"
      helm_values = {}
    },
    "1-20" = {
      version = "1.20.1"
      revision = "1-20"
      is_default_revision = true
      revisiontags_binding = "stable"
      helm_values = {}
    },
  }
```

After :
```
istio_istiod_instance = {
    "1-20" = {
      version = "1.20.1"
      revision = "1-20"
      is_default_revision = true
      revisiontags_binding = "stable"
      helm_values = {}
    },
  }
```

After a terraform apply :

```
helm list --all-namespaces | grep istio
istio-base              istio-system    3               2024-01-24 18:39:12.165734323 +0100 CET deployed        base-1.20.1                     1.20.1     
istio-cni               kube-system     3               2024-01-24 18:39:14.461434206 +0100 CET deployed        cni-1.20.1                      1.20.1     
istio-ingressgateway    istio-ingress   3               2024-01-22 16:35:38.442516623 +0100 CET deployed        gateway-1.20.1                  1.20.1     
istio-istiod-1-20       istio-system    2               2024-01-24 18:57:28.233316698 +0100 CET deployed        istiod-1.20.1                   1.20.1 
```

```
istioctl tag list
TAG         REVISION NAMESPACES
default     1-20     
prod-stable 1-20     demo
```

```
terraform console       
> module.istio-oss-stack
{
  "istio" = {
    "canary_revision" = ""
    "canary_version" = ""
    "default_revision" = "1-20"
    "ingressgateway_revision" = "prod-stable"
    "ingressgateway_version" = "1.20.1"
    "old_stable_revision" = ""
    "old_stable_version" = ""
    "stable_revision" = "1-20"
    "stable_version" = "1.20.1"
  }
}
```
