variable "ibmcloud_api_key" {
  description = "api key used to access IBM Cloud"
  type        = string
}

variable "ibm_region" {
  description = "IBM Cloud region where all resources will be deployed"
  type        = string
  default     = "global"
}

variable "resource_group" {
  description = "name of resource group used for the service(s) obtained or created"
  type        = string
  default     = "test"
}

variable "cos_instance" {
  description = "name of cos instance"
  type        = string
  default     = "test-cos-instance"
}

variable "cos_bucket_name" {
  description = "name of the cos bucket"
  type        = string
  default     = "test-cos-bucket"
}
