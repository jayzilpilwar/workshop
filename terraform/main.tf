
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


resource "google_cloudfunctions_function" "my_functions" {
  count       = length(var.cloud_functions)
  name        = var.cloud_functions[count.index].name
  description = var.cloud_functions[count.index].description
  runtime     = var.cloud_functions[count.index].runtime
  entry_point = var.cloud_functions[count.index].entry_point
  source_archive_bucket = var.backend_config
  source_archive_object = "${var.cloud_functions[count.index].name}.zip"
  available_memory_mb = 256
  timeout             = 60
  event_trigger = {
    event_type = "http"
  }

  depends_on = [
    google_storage_bucket_object["function_code"],
  ]
}

resource "google_storage_bucket_object" "function_code" {
  count = length(var.cloud_functions)

  name   = "${var.cloud_functions[count.index].name}.zip"
  bucket = var.backend_config
  source = var.cloud_functions[count.index].source_code

  depends_on = [google_cloudfunctions_function.my_functions]
}
