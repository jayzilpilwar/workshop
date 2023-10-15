variable "project" {}
variable "location" {}
variable "dataset_id" {}
variable "routine_id" {}
variable "routine_sql" {}

resource "google_bigquery_dataset" "raw" {
    dataset_id      =   "${var.dataset_id}"
    friendly_name   =   "${var.dataset_id}"
    description     =   "This is a raw layer"
    location        =   "${var.location}"
    labels  =   {
        env     = "default"
    }
}



resource "google_bigquery_routine" "routine" {
    dataset_id      = google_bigquery_dataset.raw.dataset_id
    routine_id      = "${var.routine_id}"
    routine_type    = "PROCEDURE"
    langauge        = "SQL"
    defination_body = file("${path.module}/${var.routine_sql}.sql")
    depends_on      = [ google_bigquery_dataset.raw ]
}