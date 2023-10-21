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
