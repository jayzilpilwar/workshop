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
  }))
  default = [
    {
      name        = "hello one"
      description = "Function 1 "
      runtime     = "python310"
      entry_point = "hello1"
      source_code = "transactions/cloud_function/hello1.py"
    },
    {
      name        = "hello two"
      description = "Function 2 "
      runtime     = "python310"
      entry_point = "hello2"
      source_code = "transactions/cloud_function/hello2.py"
    },
  ]
}
