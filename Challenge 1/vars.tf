variable "rg_name" {}
variable "location" {}
variable "vnetaddr" {}
variable "subnetweb" {}
variable "subnetapp" {}
variable "subnetdb" {}
variable "subnetmgmt" {}
variable "webcount" {}
variable "appcount" {}
variable "dbcount" {}
variable "username" {
  description = "The username for vm login"
  type        = string
}
variable "password" {
  description = "The password for vm login"
  type        = string
}