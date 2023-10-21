terraform {
    backend "gcs" {
        bucket = "gitaction-secrets-statefile"
        prefix = "terraform/state/transactions"
    }
}

terraform {
    backend "gcs" {
        bucket = "cfjay"
        prefix = "terraform/state/transactions"
    }
}