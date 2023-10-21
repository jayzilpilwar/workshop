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
  type    = string
  default = "transactions_sp"
}

variable "routine_sql" {
  type    = list(string)
  default = ["transaction_sp.sql", "users_sp.sql"]
}