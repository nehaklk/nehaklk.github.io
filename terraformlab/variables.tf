variable "location" {
  type    = string
  default = "westus3"
}

variable "vnet_address_space" {
  type    = list(any)
  default = ["12.2.0.0/20"]
}

variable "snet_address_space" {
  type    = list(any)
  default = ["12.2.1.0/24"]
}

variable "servername" {
  type = string
  default = "myserver"
}

variable "admin_user" {
  type = string
  default = "admin"
}

variable "admin_pass" {
  type = string
}

variable "storage_account_type" {
  type = map(any)
  default = {
    westus3        = "Standard_LRS"
    southcentralus = "Premium_LRS"
  }
}

variable "os" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
variable "resource_grp" {
  default = "krreesh-east-us-rg"
}
variable "vm_size" {  
  type = map
  default = ({
    westus3 = "Standard_B1s"
    southcentralus = "Standard_B1ms"
  })
  
}