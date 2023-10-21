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
resource "google_bigquery_routine" "bigqyery-execution" {
    count           = length(var.routine_sql)    
    dataset_id      = google_bigquery_dataset.raw.dataset_id
    routine_id      = "routine_${var.routine_id[count.index]}"
    routine_type    = "PROCEDURE"
    language        = "SQL"
    definition_body = file("bigquery/${element(var.routine_sql,count.index)}")
    depends_on      = [ google_bigquery_dataset.raw ]
}
