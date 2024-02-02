# 03 - Do an Istio In-place upgrade.

Here we expect to use the `In-place` upgrade method to upgrade an existing Istio control plane to a new `patch` version.

**Important** : Use the `canary` upgrade method if you want to upgrade to an upper `minor` version. 

[Naming scheme](https://istio.io/latest/docs/releases/supported-releases/#naming-scheme) : `  <major>.<minor>.<patch>`

## To see/check/know before upgrade.

- [Releases announcements](https://istio.io/latest/news/) page contains all versions and their changelog.
- [Prerequisites](https://istio.io/latest/docs/setup/upgrade/helm/#prerequisites)
- [Upgrade steps](https://istio.io/latest/docs/setup/upgrade/helm/#upgrade-steps)
  > Before upgrading Istio, it is recommended to run the istioctl x precheck command to make sure the upgrade is compatible with your environment.

  ```
  $ istioctl x precheck
  ✔ No issues found when checking the cluster. Istio is safe to install or upgrade!
    To get started, check out <https://istio.io/latest/docs/setup/getting-started/>
  ```
- [Control Plane/Data Plane Skew](https://istio.io/latest/docs/releases/supported-releases/#control-planedata-plane-skew)
  > The Istio control plane can be one version ahead of the data plane. However, the data plane cannot be ahead of control plane.
  
  > As of now, data plane to data plane is compatible across all versions; however, this may change in the future.

- [Istio CNI](https://istio.io/latest/docs/setup/additional-setup/cni/#upgrade) :
  > The CNI plugin at version 1.x is compatible with control plane at version 1.x-1, 1.x, and 1.x+1, which means CNI and control plane can be upgraded in any order, as long as their version difference is within one minor version.

## In-place upgrade workflow : Official documentation VS Terraform istio-oss-stack module.

### Official documentation

The official [In-place upgrade workflow when you use Helm](https://istio.io/latest/docs/setup/upgrade/helm/#in-place-upgrade) is summarized here : 


1. Upgrade `CRDs`
2. Upgrade Istio `base` chart (without CRDs)
3. Upgrade Istio `discovery` chart
4. Upgrade Istio `gateway` chart (optional)

Extra steps :
- If Istio `CNI` is used, you have to manage its upgrade.

### Terraform istio-oss-stack module

In the other hand, the `istio-oss-stack` terraform module follows an opiniated logic workflow to automate some tasks and guide the user.

**First step** : `CRDs`, `base`, `discovery`, `CNI`

1. Upgrade the `version` attribute for your Istiod instance (see the `istio_istiod_instance` variable).
2. Do a terraform apply.

So through the `istio_istiod_instance` variable you manage all this components as a whole. Thereafter we will refer to this set as the `istiod_instance`.

**Second step** : istio-ingressgateway (`gateway`)

1. Upgrade the version through the `istio_ingressgateway_version` variable.
2. Do a terraform apply.

## Instructions

### 1. Upgrade the `istiod_instance`

Use the `version` attribute to upgrade the patch version. Here we upgrade the `patch` version from `1.19.3` to `1.19.4`.

Before : 

```
istio_istiod_instance = {
  "1-19" = {
    version = "1.19.3"
    revision = "1-19"
    is_default_revision = true
    revisiontags_binding = "stable"
    helm_values = {}
  },
}
```

After : 
```
istio_istiod_instance = {
    "1-19" = {
      version = "1.19.4"
      revision = "1-19"
      is_default_revision = true
      revisiontags_binding = "stable"
      helm_values = {}
    },
  }
```

After a terraform apply :

```
helm list --all-namespaces | grep istio

istio-base              istio-system    2               2024-01-21 09:56:38.371299286 +0100 CET deployed        base-1.19.4                     1.19.4     
istio-cni               kube-system     2               2024-01-21 09:56:40.330041031 +0100 CET deployed        cni-1.19.4                      1.19.4     
istio-ingressgateway    istio-ingress   1               2024-01-20 14:06:49.429322562 +0100 CET deployed        gateway-1.19.3                  1.19.3     
istio-istiod-1-19       istio-system    2               2024-01-21 09:56:42.116292472 +0100 CET deployed        istiod-1.19.4                   1.19.4
```

At this step, the control plane has been upgraded. 

You have to do a rollout of your injected application workload to upgrade the version of the proxy. 

After that, the expected result is the following : 
```
istioctl proxy-status -n demo

NAME                                     CLUSTER        CDS        LDS        EDS        RDS        ECDS         ISTIOD                          VERSION
details-v1-7bd85cccdd-zn9hz.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
productpage-v1-5bbbf86cb7-rg6ht.demo     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4     1.19.4
ratings-v1-5947d5c67c-zbj48.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4     1.19.4
reviews-v1-7584759c6d-xwmqt.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
reviews-v2-659d684c8-kfgq9.demo          Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4     1.19.4
reviews-v3-9cd79fcf-c2msw.demo           Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4     1.19.4
```

### 2. Upgrade the istio-ingressgateway (gateway)

Upgrade the version through the `istio_ingressgateway_version` variable.

Before : 
```
istio_ingressgateway_version = "1.19.3"
```

After :
```
istio_ingressgateway_version = "1.19.4"
```

After a terraform apply :
```
helm list --all-namespaces | grep istio

istio-base              istio-system    2               2024-01-21 09:56:38.371299286 +0100 CET deployed        base-1.19.4                     1.19.4     
istio-cni               kube-system     2               2024-01-21 09:56:40.330041031 +0100 CET deployed        cni-1.19.4                      1.19.4     
istio-ingressgateway    istio-ingress   2               2024-01-21 11:27:03.912508337 +0100 CET deployed        gateway-1.19.4                  1.19.4     
istio-istiod-1-19       istio-system    2               2024-01-21 09:56:42.116292472 +0100 CET deployed        istiod-1.19.4                   1.19.4
```

The `istio-ingressgateway` release has been upgraded, and the control plane has been upgraded at the previous step. You now need to do a rollout of the `istio-ingress/istio-ingressgateway` to upgrade the version of the proxy.

After that, the expected result is the following :
```
istioctl proxy-status -n istio-ingress

NAME                                                   CLUSTER        CDS        LDS        EDS        RDS        ECDS         ISTIOD                          VERSION
istio-ingressgateway-c47cc6c97-2nkrh.istio-ingress     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
istio-ingressgateway-c47cc6c97-bjqlf.istio-ingress     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
```

## Progress report

**Existing revision tags** :

No change here.

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
    "ingressgateway_version" = "1.19.4"
    "old_stable_revision" = ""
    "old_stable_version" = ""
    "stable_revision" = "1-19"
    "stable_version" = "1.19.4"
  }
}
```
