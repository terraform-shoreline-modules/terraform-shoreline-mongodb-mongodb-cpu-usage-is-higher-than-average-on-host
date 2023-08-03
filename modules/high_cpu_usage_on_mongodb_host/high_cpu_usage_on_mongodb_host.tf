resource "shoreline_notebook" "high_cpu_usage_on_mongodb_host" {
  name       = "high_cpu_usage_on_mongodb_host"
  data       = file("${path.module}/data/high_cpu_usage_on_mongodb_host.json")
  depends_on = [shoreline_action.invoke_mongo_profiling_maintenance]
}

resource "shoreline_file" "mongo_profiling_maintenance" {
  name             = "mongo_profiling_maintenance"
  input_file       = "${path.module}/data/mongo_profiling_maintenance.sh"
  md5              = filemd5("${path.module}/data/mongo_profiling_maintenance.sh")
  description      = "Optimize database queries and indexes to reduce the load on the database and improve CPU usage."
  destination_path = "/agent/scripts/mongo_profiling_maintenance.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_mongo_profiling_maintenance" {
  name        = "invoke_mongo_profiling_maintenance"
  description = "Optimize database queries and indexes to reduce the load on the database and improve CPU usage."
  command     = "`chmod +x /agent/scripts/mongo_profiling_maintenance.sh && /agent/scripts/mongo_profiling_maintenance.sh`"
  params      = ["HOSTNAME","DATABASE_NAME","MONGODB_PORT","USERNAME","PASSWORD"]
  file_deps   = ["mongo_profiling_maintenance"]
  enabled     = true
  depends_on  = [shoreline_file.mongo_profiling_maintenance]
}

