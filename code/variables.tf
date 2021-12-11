variable "sub_environment" {
  description   = "sub environment value coming from terragrunt file"
}

variable "location" {
  description   = "Location of the resource group."
}

variable "subscription_id" {
  default       = "db371aa4-50d0-45d5-866b-3638e8a8e53d"
  description   = "subscription id"
}

variable "tenant_id" {
  default       = "3026ab1c-66a5-46df-83be-7b183a607557"
  description   = "tenant id"
}