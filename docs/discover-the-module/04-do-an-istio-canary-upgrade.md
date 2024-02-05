# 04 - Do an Istio Canary upgrade.

Here we use the `Canary` upgrade method to install another Istio control plane version. We will be able to validate its compatibility with our actual setup/workload before replacing the existing version.

**Important** : `Canary` is the recommanded upgrade method. 

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

## Canary upgrade workflow : Official documentation VS Terraform istio-oss-stack module.

### Official documentation

The official [In-place upgrade workflow when you use Helm](https://istio.io/latest/docs/setup/upgrade/helm/#canary-upgrade-recommended) is summarized here : 


1. Upgrade `CRDs` to the canary version.
2. Install a canary version of the `discovery` chart by setting the revision to something like "canary" (ex: revision=canary) 
3. Install a canary revision of the `gateway` chart by setting the revision value to the value used into the previous step (ex: revision=canary)
4. "Test or migrate existing workloads to use the canary control plane" (See [here](https://istio.io/latest/docs/setup/upgrade/canary/#data-plane))
5. Uninstall the old control plane
6. "Upgrade the Istio `base` chart, making the new revision the default". 

Extra steps :
- If Istio `CNI` is used, you have to manage its upgrade.
- If Kiali is used and your installation is revisioned, you have to reconfigure it in a way that it points to the new control plane version. 

### Terraform istio-oss-stack module

As for the In-place upgrade method, the `istio-oss-stack` terraform module follows an opiniated logic workflow to automate some tasks and guide the user.

**Important** : Currently the `istio-oss-stack` terraform module does not support to add a canary revision of the `gateway`. The module only allows to point the existing `istio-ingressgateway` to either the `stable` or the `canary` revision.

 #FIXME 

## Checks
**Automated**
- `version` should be a semantic version.
- `revisiontags_binding` should be defined.
- `revisiontags_binding` cannot have the same value for two istiod_instance
- `is_default_revision` must be defined.
- `is_default_revision` can only have the `stable` value if `revision_binding` has the value `stable`.
- `revision` value cannot contain a dot.

## Instructions

| Supported matrix for istiod_instance | |   |     |
| --------   | --- | --- | --- |
| stable     | 1   | 1   | 1   |
| canary     | 0   | 1   | 0   |
| old-stable | 0   | 0   | 1   |

### 1. Add a `canary` istiod_instance

Here, we use the `istio_istiod_instance` variable to add new istiod_instance. A `canary` one.

**Important** : `canary` version must be higher than the `stable` version.

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
    "1-20" = {
      version = "1.20.1"
      revision = "1-20"
      is_default_revision = false
      revisiontags_binding = "canary"
      helm_values = {}
    },
  }
```

After a terraform apply :

```
helm list --all-namespaces | grep istio

istio-base              istio-system    2               2024-01-21 09:56:38.371299286 +0100 CET deployed        base-1.19.4                     1.19.4     
istio-cni               kube-system     2               2024-01-21 09:56:40.330041031 +0100 CET deployed        cni-1.19.4                      1.19.4     
istio-ingressgateway    istio-ingress   2               2024-01-21 11:27:03.912508337 +0100 CET deployed        gateway-1.19.4                  1.19.4     
istio-istiod-1-19       istio-system    2               2024-01-21 09:56:42.116292472 +0100 CET deployed        istiod-1.19.4                   1.19.4     
istio-istiod-1-20       istio-system    1               2024-01-22 15:33:38.642276123 +0100 CET deployed        istiod-1.20.1                   1.20.1
```

We see that a new control plane has been added,

```
istioctl tag list

TAG         REVISION NAMESPACES
default     1-19     
prod-canary 1-20     
prod-stable 1-19     demo
```

as a new `revisiontag`: "prod-canary", which points to the new `revision` "1-20". The `default revision` is unchanged and logically the version of the data plane (proxies) is also unchanged, even after a rollout.

```
istioctl proxy-status                 

NAME                                                   CLUSTER        CDS        LDS        EDS        RDS        ECDS         ISTIOD                          VERSION
details-v1-7bd85cccdd-6klqk.demo                       Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4     1.19.4
istio-ingressgateway-c47cc6c97-2nkrh.istio-ingress     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
istio-ingressgateway-c47cc6c97-bjqlf.istio-ingress     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
productpage-v1-5bbbf86cb7-xq7ld.demo                   Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
ratings-v1-5947d5c67c-2xc92.demo                       Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
reviews-v1-7584759c6d-jsxxr.demo                       Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
reviews-v2-659d684c8-n5vst.demo                        Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4     1.19.4
reviews-v3-9cd79fcf-sjntp.demo                         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4     1.19.4

```

```
terraform console

> module.istio-oss-stack
{
  "istio" = {
    "canary_revision" = "1-20"
    "canary_version" = "1.20.1"
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

Terraform output now shows informations into the lines which relate to `canary`.

### 2 - Test or migrate existing workloads to use the canary control plane

**Important** : It's not possible to override namespace injection (ex: `istio.io/rev: prod-stable`) by setting pod injection (ex: `istio.io/rev: prod-canary`). 

The module follows the "Revision tags" principle :
> **Revision tags** are stable identifiers that point to revisions and can be used to avoid relabeling namespaces. 
[Source](https://istio.io/latest/docs/setup/upgrade/canary/#stable-revision-labels)

So, here are the steps to evaluate the behavior of the new Istiod version :

1. Reconfigure the label to `istio.io/rev: prod-canary` on specific or all the namespaces of your app workload. 
2. Do a rollout of the respective deployments
3. Use the command `istioctl proxy-status` to verify that the proxy version used by the pod is the one which is linked to the `prod-canary` Revision tag.


    Example : 
    
    ```
    istioctl proxy-status -n demo

    NAME                                     CLUSTER        CDS        LDS        EDS        RDS        ECDS         ISTIOD                           VERSION
    details-v1-7bd85cccdd-ghc6d.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4      1.19.4
    productpage-v1-5bbbf86cb7-xskw9.demo     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4      1.19.4
    ratings-v1-5947d5c67c-snv2d.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4      1.19.4
    reviews-v1-849f4b444b-xdp6g.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4      1.19.4
    reviews-v2-7f6d6b9fcb-q868n.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-20-7497b85cdf-nff8b     1.20.1
    reviews-v3-75fd4558c7-ksfxt.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-20-7497b85cdf-nff8b     1.20.1
    ```
   
4. Evaluate the impact of the new Istiod instance on your `app workload`. # FIXME
5. Relabel `app workload namespace` to `istio.io/rev: prod-stable`. # FIXME

Info : A rollout is not expected here as the `prod-stable` tag will be bound to the new revision in step 4.

### 3 - Upgrade the `istio-ingressgateway`

1. Upgrade the `gateway` chart version : 

    Before : 
    ```
    istio_ingressgateway_enabled = true
    istio_ingressgateway_version = "1.19.4"
    istio_ingressgateway_revision_binding = "stable"
    istio_ingressgateway_overlay_helm_values = {}
    ```

    After :
    ``` 
    istio_ingressgateway_enabled = true
    istio_ingressgateway_version = "1.20.1"
    istio_ingressgateway_revision_binding = "stable"
    istio_ingressgateway_overlay_helm_values = {}
    ```
    
2. Apply the change with a `terraform apply`

    After : 

    ```
    helm list -n istio-ingress
     
    istio-ingressgateway    istio-ingress   3               2024-01-22 16:35:38.442516623 +0100 CET deployed        gateway-1.20.1                  1.20.1
    ```

3. Configure the `istio_ingressgateway_revision_binding` variable to point to the `canary` revision.

    Before : 
    ```
    istio_ingressgateway_enabled = true
    istio_ingressgateway_version = "1.20.1"
    istio_ingressgateway_revision_binding = "stable"
    istio_ingressgateway_overlay_helm_values = {}
    ```

    After :
    ``` 
    istio_ingressgateway_enabled = true
    istio_ingressgateway_version = "1.20.1"
    istio_ingressgateway_revision_binding = "canary"
    istio_ingressgateway_overlay_helm_values = {}
    ```

4. Do a rollout of the `istio-ingress/istio-ingressgateway` deployment.
5. Use the command `istioctl proxy-status` to verify that the proxy version used by the pods of the `istio-ingress/istio-ingressgateway` deployment is the one which is linked to the `prod-canary` Revision tag.
6. Evaluate the impact of the new Istiod `canary` instance on the `istio-ingressgateway`. # FIXME
7. Reconfigure the `istio_ingressgateway_revision_binding` variable to point to the `stable` revision.

    Before : 
    ```
    istio_ingressgateway_enabled = true
    istio_ingressgateway_version = "1.20.1"
    istio_ingressgateway_revision_binding = "canary"
    istio_ingressgateway_overlay_helm_values = {}
    ```

    After :
    ``` 
    istio_ingressgateway_enabled = true
    istio_ingressgateway_version = "1.20.1"
    istio_ingressgateway_revision_binding = "stable"
    istio_ingressgateway_overlay_helm_values = {}
    ```

Info : A rollout is not expected here as the `prod-stable` tag will be bound to the new revision in step 4.

### 4 - Promote new revision as the **default**, **prod-stable** one.

For revision `1-19` :
- Update the `is_default_revision` value to `false`.
- Update the `revisiontags_binding` value to `old-stable`

For revision `1-20` :
- Update the `is_default_revision` value to `true`. 
- Update the `revisiontags_binding` value to `stable`


After :
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

After a terraform apply :

Below results are as expected :
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

Example : 
    
```
istioctl proxy-status

NAME                                                    CLUSTER        CDS        LDS        EDS        RDS        ECDS         ISTIOD                           VERSION
details-v1-7bd85cccdd-ghc6d.demo                        Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4      1.19.4
productpage-v1-5bbbf86cb7-xskw9.demo                    Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4      1.19.4
ratings-v1-5947d5c67c-snv2d.demo                        Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-mhcl4      1.19.4
reviews-v1-849f4b444b-xdp6g.demo                        Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-c88d4d9bd-kx5h4      1.19.4
reviews-v2-7f6d6b9fcb-q868n.demo                        Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-20-7497b85cdf-nff8b     1.20.1
reviews-v3-75fd4558c7-ksfxt.demo                        Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-20-7497b85cdf-nff8b     1.20.1
istio-ingressgateway-74767548cc-8tfgg.istio-ingress     Kubernetes     SYNCED     SYNCED     SYNCED     NOT SENT   NOT SENT     istiod-1-20-7497b85cdf-rmtks     1.20.1
istio-ingressgateway-74767548cc-vrsml.istio-ingress     Kubernetes     SYNCED     SYNCED     SYNCED     NOT SENT   NOT SENT     istiod-1-20-7497b85cdf-rmtks     1.20.1
```
