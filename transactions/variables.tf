variable "project" {
  type    = string
  default = "dulcet-abacus-397714"
}

variable "location" {
  type    = string
  default = "US"
}

variable "dataset_id" {
  type    = string
  default = "transactions"
}

variable "routine_id" {
  type    = list(string)
  default =  ["transaction_sp", "users_sp"]
}

variable "routine_sql" {
  type    = list(string)
  default = ["transaction_sp.sql", "users.sql"]
}

variable "cloud_functions" {
  type = list(object({
    name        = string
    description = string
    runtime     = string
    entry_point = string
    source_code = string
    cf_name = string
    region = string
    project_id = string
  }))
  default = [
    {
      name        = "hello1.zip"
      description = "Function 1 "
      runtime     = "python310"
      entry_point = "hello1"
      source_code = "cloud_function/hello1"
      cf_name = "hello1"
      region = "us-east1"
      project_id = "dulcet-abacus-397714"
    },
    {
      name        = "hello2.zip"
      description = "Function 2 "
      runtime     = "python310"
      entry_point = "hello2"
      source_code = "cloud_function/hello2"
      cf_name = "hello2"
      region = "us-east1"
      project_id = "dulcet-abacus-397714"
    },
  ]
}


variable "backend_config" {
  type    = string
  default = "cfjay"
}

variable "service_account_email" {
  type    = string
  default = "gitactions-service@dulcet-abacus-397714.iam.gserviceaccount.com"
}

