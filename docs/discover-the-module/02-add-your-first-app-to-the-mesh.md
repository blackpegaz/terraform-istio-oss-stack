# Add you first application to the mesh.

Here I use the example of the [Bookinfo application](https://istio.io/latest/docs/examples/bookinfo/) provided by the Istio project : 


## Instructions

1. Clone Istio GitHub repository :
```
git clone https://github.com/istio/istio.git
cd istio
```

2. Create a `demo` namespace 
```
kubectl create ns demo
```

3. Add the label which contains the tag which corresponds to the `stable` revision (for me, its the `prod-stable` tag) :
```
kubectl label namespace demo istio.io/rev=prod-stable
```

**Hint** : 
```
istioctl tag list  
TAG         REVISION NAMESPACES
default     1-19     
prod-stable 1-19     
```

4. Deploy the resources associated to the Bookinfo application :
```
kubectl -n demo apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl -n demo apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl -n demo apply -f samples/bookinfo/networking/destination-rule-all.yaml
```

## Progress report

The namespace `demo` is now associated with the tag `prod-stable` :
```
istioctl tag list

TAG         REVISION NAMESPACES
default     1-19
prod-stable 1-19     demo
```

Pods into the `demo` namespace have been injected. They are linked to the tag `prod-stable`, which is linked to the revision `1-19`, which at this time identifies the istiod instance in version `1.19.3`. 
```
istioctl proxy-status -n demo

NAME                                     CLUSTER        CDS        LDS        EDS        RDS        ECDS         ISTIOD                           VERSION
details-v1-7745b6fcf4-mv7pn.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-5746c86d75-2psbj     1.19.3
productpage-v1-6f89b6c557-b6k7z.demo     Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-5746c86d75-mkq9c     1.19.3
ratings-v1-77bdbf89bb-4rrlj.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-5746c86d75-2psbj     1.19.3
reviews-v1-667b5cc65d-rdnlm.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-5746c86d75-2psbj     1.19.3
reviews-v2-6f76498fc8-fsxpl.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-5746c86d75-2psbj     1.19.3
reviews-v3-5d8667cc66-gsfjj.demo         Kubernetes     SYNCED     SYNCED     SYNCED     SYNCED     NOT SENT     istiod-1-19-5746c86d75-2psbj     1.19.3
```
