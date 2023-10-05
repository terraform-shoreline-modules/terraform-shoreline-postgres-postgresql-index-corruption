resource "shoreline_notebook" "postgresql_index_corruption" {
  name       = "postgresql_index_corruption"
  data       = file("${path.module}/data/postgresql_index_corruption.json")
  depends_on = [shoreline_action.invoke_db_status_check,shoreline_action.invoke_pg_restore_db]
}

resource "shoreline_file" "db_status_check" {
  name             = "db_status_check"
  input_file       = "${path.module}/data/db_status_check.sh"
  md5              = filemd5("${path.module}/data/db_status_check.sh")
  description      = "Database maintenance: Incorrect execution of database maintenance tasks, such as vacuuming or reindexing, can cause index corruption."
  destination_path = "/agent/scripts/db_status_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "pg_restore_db" {
  name             = "pg_restore_db"
  input_file       = "${path.module}/data/pg_restore_db.sh"
  md5              = filemd5("${path.module}/data/pg_restore_db.sh")
  description      = "If repair is not possible or does not resolve the issue, consider restoring from a backup of the database that was taken prior to the index corruption issue."
  destination_path = "/agent/scripts/pg_restore_db.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_db_status_check" {
  name        = "invoke_db_status_check"
  description = "Database maintenance: Incorrect execution of database maintenance tasks, such as vacuuming or reindexing, can cause index corruption."
  command     = "`chmod +x /agent/scripts/db_status_check.sh && /agent/scripts/db_status_check.sh`"
  params      = ["DATABASE_PATH","DATABASE_NAME"]
  file_deps   = ["db_status_check"]
  enabled     = true
  depends_on  = [shoreline_file.db_status_check]
}

resource "shoreline_action" "invoke_pg_restore_db" {
  name        = "invoke_pg_restore_db"
  description = "If repair is not possible or does not resolve the issue, consider restoring from a backup of the database that was taken prior to the index corruption issue."
  command     = "`chmod +x /agent/scripts/pg_restore_db.sh && /agent/scripts/pg_restore_db.sh`"
  params      = ["PATH_TO_BACKUP_FILE","DATABASE_NAME"]
  file_deps   = ["pg_restore_db"]
  enabled     = true
  depends_on  = [shoreline_file.pg_restore_db]
}

