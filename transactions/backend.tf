terraform {
    backend "gcs" {
        bucket = "workshop_tfstate"
        prefix = "teraform/state/transactions"
    }
}