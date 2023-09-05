terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.41.0"
    }
  }
}
