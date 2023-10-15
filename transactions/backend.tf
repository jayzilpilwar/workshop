terraform {
    backend "gcs" {
        bucket = "gitaction-secrets-statefile"
        prefix = "terraform/state/transactions"
    }
}