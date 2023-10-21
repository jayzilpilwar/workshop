
resource "google_bigquery_dataset" "raw" {
    dataset_id      =   "${var.dataset_id}"
    friendly_name   =   "${var.dataset_id}"
    description     =   "This is a raw layer"
    location        =   "${var.location}"
    labels  =   {
        env     = "default"
    }
}
# resource "google_bigquery_routine" "bigqyery-execution" {
#     count           = length(var.routine_sql)    
#     dataset_id      = google_bigquery_dataset.raw.dataset_id
#     routine_id      = "routine_${var.routine_id[count.index]}"
#     routine_type    = "PROCEDURE"
#     language        = "SQL"
#     definition_body = file("bigquery/${element(var.routine_sql,count.index)}")
#     depends_on      = [ google_bigquery_dataset.raw ]
# }


# resource "google_cloudfunctions_function" "my_functions" {
#   count       = length(var.cloud_functions)
#   name        = var.cloud_functions[count.index].name
#   description = var.cloud_functions[count.index].description
#   runtime     = var.cloud_functions[count.index].runtime
#   entry_point = var.cloud_functions[count.index].entry_point
#   source_archive_bucket = var.backend_config
#   source_archive_object = "gcf-sources-389671115938-us-east1/${var.cloud_functions[count.index].name}.zip"
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
#   source  = file("cloud_function/${var.cloud_functions[count.index].source_code}")
#   depends_on = [google_cloudfunctions_function.my_functions]
  

# }



resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name                        = "${random_id.default.hex}-gcf-source" # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  count       = length(var.cloud_functions)  
  type        = "zip"
  output_path = file("/tmp/${var.cloud_functions[count.index].name}.zip")
  source_dir  = "cloud_function/${var.cloud_functions[count.index].name}/"
}
resource "google_storage_bucket_object" "object" {
  count  = length(var.cloud_functions)   
  name   = "${var.cloud_functions[count.index].name}.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "default" {
  count       = length(var.cloud_functions) 
  name        = var.cloud_functions[count.index].name
  location    = "us"
  description = var.cloud_functions[count.index].description

  build_config {
    runtime     = var.cloud_functions[count.index].runtime
    entry_point = var.cloud_functions[count.index].entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}

output "function_uri" {
  value = google_cloudfunctions2_function.default.service_config[0].uri
}