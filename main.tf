data "ibm_resource_group" "cos_group" {
  name = var.resource_group
}

resource "ibm_resource_instance" "cos_instance1" {
  name              = var.cos_instance
  resource_group_id = data.ibm_resource_group.cos_group.id
  service           = "cloud-object-storage"
  plan              = "lite"
  location          = var.ibm_region
}

resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name          = var.cos_bucket_name
  resource_instance_id = ibm_resource_instance.cos_instance1.id
  single_site_location = "ams03"
  storage_class = "standard"
}
