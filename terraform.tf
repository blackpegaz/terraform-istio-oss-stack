terraform {
  required_version = "~> 1.5.5"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.3"
    }
  }
}
