
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


# resource "google_cloudfunctions_function" "my_functions" {
#   count       = length(var.cloud_functions)
#   name        = var.cloud_functions[count.index].name
#   description = var.cloud_functions[count.index].description
#   runtime     = var.cloud_functions[count.index].runtime
#   entry_point = var.cloud_functions[count.index].entry_point
#   source_archive_bucket = var.backend_config
#   source_archive_object = var.cloud_functions[count.index].source_code
#   available_memory_mb = 256
#   timeout             = 60  
#   region              = "us-east1"
#   service_account_email = var.service_account_email
#   event_trigger {
#     event_type = "google.storage.object.finalize"
#     resource   = var.backend_config
#   }
# }

# resource "google_storage_bucket_object" "function_code" {
#   count = length(var.cloud_functions)
#   name   = "${var.cloud_functions[count.index].name}.zip"
#   bucket = var.backend_config
#   source  = "cloud_function/${var.cloud_functions[count.index].name}/${var.cloud_functions[count.index].source_code}"
#   depends_on = [google_cloudfunctions_function.my_functions]

# }


resource "google_storage_bucket_object" "archive" {
  count =  length(var.cloud_functions)  
  name   = var.cloud_functions[count.index].name
  bucket = var.backend_config
  source = var.cloud_functions[count.index].source_code
}


resource "google_cloudfunctions_function" "function" {
  count                        = length(var.cloud_functions)  
  name                         = var.cloud_functions[count.index].cf_name
  description                  = var.cloud_functions[count.index].description
  runtime                      = var.cloud_functions[count.index].runtime
  available_memory_mb          = 128
  source_archive_bucket        = var.backend_config
  source_archive_object        = google_storage_bucket_object.archive.name
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = var.cloud_functions[count.index].entry_point
  region                       = "us-east1"
  
  }


