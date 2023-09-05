provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  resource_group   = var.resource_group
  region           = var.ibm_region
}
