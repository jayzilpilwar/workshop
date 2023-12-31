
# resource "google_bigquery_dataset" "raw" {
#     dataset_id      =   "${var.dataset_id}"
#     friendly_name   =   "${var.dataset_id}"
#     description     =   "This is a raw layer"
#     location        =   "${var.location}"
#     labels  =   {
#         env     = "default"
#     }
# }
# resource "google_bigquery_routine" "bigqyery-execution" {
#     count           = length(var.routine_sql)    
#     dataset_id      = google_bigquery_dataset.raw.dataset_id
#     routine_id      = "routine_${var.routine_id[count.index]}"
#     routine_type    = "PROCEDURE"
#     language        = "SQL"
#     definition_body = file("bigquery/${element(var.routine_sql,count.index)}")
#     depends_on      = [ google_bigquery_dataset.raw ]
# }




resource "google_storage_bucket" "Cloud_function_bucket" {
    name     = "cloud-function-${var.project}"
    location = var.region
    project  =  var.project
}

resource "google_storage_bucket" "input_bucket" {
    name     = "input-${var.project}"
    location = var.region
    project  = var.project
}

# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  count    = length(var.cloud_functions)
  type        = "zip"
  source_dir  = var.cloud_functions[count.index].source_code
  output_path = "cloud_function/${var.cloud_functions[count.index].cf_name}.zip"
}

# Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
resource "google_storage_bucket_object" "zip" {
  count        = length(var.cloud_functions)  
  source       = "cloud_function/${var.cloud_functions[count.index].cf_name}.zip"
  content_type = "application/zip"
  name         = "${var.cloud_functions[count.index].cf_name}.zip"
  bucket       = "cloud-function-${var.cloud_functions[count.index].project_id}"
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    data.archive_file.source
  ]
}


# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "Cloud_function" {
  count                 = length(var.cloud_functions) 
  name                  = var.cloud_functions[count.index].cf_name
  description           = "Cloud-function will get trigger once file is uploaded in input-${var.cloud_functions[count.index].project_id}"
  runtime               = var.cloud_functions[count.index].runtime
  project               = var.cloud_functions[count.index].project_id
  region                = var.cloud_functions[count.index].region
  source_archive_bucket = "cloud-function-${var.cloud_functions[count.index].project_id}"
  source_archive_object = "${var.cloud_functions[count.index].cf_name}.zip"
  entry_point           = var.cloud_functions[count.index].entry_point
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "input-${var.project}"
  }
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.zip,
  ]
}
