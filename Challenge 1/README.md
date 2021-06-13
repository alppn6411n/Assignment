# Challenge1

## Objective

Three tier IaC with terraform and Azure

## Architecture

![IaC](https://user-images.githubusercontent.com/13744262/121768723-4726ae80-cb7d-11eb-86de-cdaf2bf38ddd.png)

## Security Considerations
```
- No VMs accessible publicly using ssh except the bastion host.
- Traffic flow 
  user -> external LB -> web tier -> internal LB -> app tier -> internal LB -> db tier
- web -> app - YES
  web -> db  - NO
  app -> db  - YES
  app -> web - NO
  db -> web  - NO
  db -> app  - NO
  bastion -> web, app ,db - YES (ssh)
  web, app, db -> bastion - NO
```

## Requirements

- azure account 
- az-cli
- terraform

## Variables

We can change few of the parameters such as vnet and subnet address spaces by edting the terraform.tfvars
Please feel free to change according to the requirements.
```
rg_name    = "sample" (resource group)
location   = "eastus" (location)
vnetaddr   = "10.0.0.0/16" (vnet address space)
subnetweb  = "10.0.1.0/24" (web subnet CIDR)
subnetapp  = "10.0.2.0/24" (app subnet CIDR)
subnetdb   = "10.0.3.0/24" (db subnet CIDR)
subnetmgmt = "10.0.4.0/24" (mgmt subnet CIDR)
webcount   = 2 (number of web vms)
appcount   = 2 (number of app vms)
dbcount    = 2 (number of db vms)
```

## Usage

- Login to az account using az-cli
- Create environment variables for VM username and password.(Better security wise than hardcoding to variables)
  - export TF_VAR_username=username (user name) 
  - export TF_VAR_password=password (strong password)
- terraform init
- terraform workspace new prod (optional, by default, value is "default")
- terraform plan
- terraform apply

## NOTE
It is recommended that state file to be stored in az storage. (As terraform state contains hard coded sensitive content)
