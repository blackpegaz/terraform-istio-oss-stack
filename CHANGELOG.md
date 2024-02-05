# 1.0.0 (2024-02-05)


### Bug Fixes

* **jaeger-instance:** Add a way to configure affinity rules ([bdf1d9a](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/bdf1d9ae9c13ed8b00f2abeaa99770ca4c4cd730))
* **semantic-release:** Update checkout and semantic-release-action version to v4 ([49d1b68](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/49d1b68dff6720cecd4746401b3ba249e8724ab8))


### Features

* Add variable to control the verbosity of the output for CRDs resources. ([2b14fc2](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/2b14fc244f14bec27db197db305832724ca4c07d))
* Add variable validation to set a default revision when there's only one revision ([ebd0b4e](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/ebd0b4ed569ed7423adf7dec2980ea2b06d96b52))
* Enable all prevent destroy ([265dc8b](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/265dc8b915f77d9de8ad42dc2a28ae07419f3fb5))
* Important changes on the module, especially istiod (instance, revision, revisiontags) to simplify its usage for the end user. ([d870a85](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/d870a85388671de4cb702b130bd168dbf13b21ed))
* Important changes on the module, especially istiod (instance, revision, revisiontags) to simplify its usage for the end user. ([8a659b4](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/8a659b44ff6f20d94b5804d86aa20efb444285b0))
* **istio-base-crds:** Install only if istio_enabled is at true ([8ec2eda](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/8ec2edab29030739a93cc76398ef67278ef78759))
* **istio-base:** Add CRDs management ([5dbccaa](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/5dbccaa84997603a819eae3c22549d947c899bd4))
* **istio-base:** Enable server_side_apply and wait for kubectl_manifest resources ([9c4e83d](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/9c4e83de7a450129bf08868b212da1d7f9b03244))
* **istio-ingressgateway:** Add a condition to only create backendconfig when platform is GCP ([d2e851d](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/d2e851d7ed277c5cf57e3593250487810f937c49))
* **istio-ingressgateway:** Revert to default behviour for namespace creation ([c4a1060](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/c4a1060aa02b55911e098ef2bbd71449c880b3e9))
* **istio-ingressgateway:** Update variable validation to include 'old-stable' revision. ([4c83466](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/4c8346666cc1f4e7af6b1f27b8fac7c0765a813f))
* massive commit to split ([c0e98a1](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/c0e98a1eec6a5a791bd535acbee0051124f48d37))
* New way to manage revisiontags. ([0eb3846](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/0eb384653ad4506ba79e124a1764e0a1c978b08c))
* **prometheus:** URL is now set automatically if embedded kube-prometheus-stack is enabled ([97548d6](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/97548d6eb91c04ab227410c6b322356610e20700))

# [1.1.0](https://github.com/blackpegaz/terraform-istio-oss-stack/compare/v1.0.0...v1.1.0) (2024-01-07)


### Features

* Enable all prevent destroy ([265dc8b](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/265dc8b915f77d9de8ad42dc2a28ae07419f3fb5))
* **istio-base-crds:** Install only if istio_enabled is at true ([8ec2eda](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/8ec2edab29030739a93cc76398ef67278ef78759))
* **istio-base:** Add CRDs management ([5dbccaa](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/5dbccaa84997603a819eae3c22549d947c899bd4))
* **istio-base:** Enable server_side_apply and wait for kubectl_manifest resources ([9c4e83d](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/9c4e83de7a450129bf08868b212da1d7f9b03244))
* **istio-ingressgateway:** Revert to default behviour for namespace creation ([c4a1060](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/c4a1060aa02b55911e098ef2bbd71449c880b3e9))
* massive commit to split ([c0e98a1](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/c0e98a1eec6a5a791bd535acbee0051124f48d37))

# 1.0.0 (2024-01-07)


### Bug Fixes

* **semantic-release:** Update checkout and semantic-release-action version to v4 ([49d1b68](https://github.com/blackpegaz/terraform-istio-oss-stack/commit/49d1b68dff6720cecd4746401b3ba249e8724ab8))
