provider "snowflake" {
  username = var.your_username
  password = var.your_password
  account  = var.your_account_url
}

resource "snowflake_role" "example_role" {
  name = "my_role"
}

resource "snowflake_database" "example_database" {
  name = "my_database"
}

resource "snowflake_schema" "example_schema" {
  name     = "my_schema"
  database = snowflake_database.example_database.name
}

resource "snowflake_user" "example_user" {
  name     = "my_user"
  password = var.user_password
  roles    = [snowflake_role.example_role.name]
}

resource "snowflake_grant" "example_grant" {
  privilege = "USAGE"
  on        = "DATABASE ${snowflake_database.example_database.name}"
  to        = snowflake_role.example_role.name
}

resource "snowflake_grant" "example_schema_grant" {
  privilege = "USAGE"
  on        = "SCHEMA ${snowflake_schema.example_schema.name} IN DATABASE ${snowflake_database.example_database.name}"
  to        = snowflake_role.example_role.name
}

resource "snowflake_grant" "example_user_grant" {
  privilege = "USAGE"
  on        = "DATABASE ${snowflake_database.example_database.name}"
  to        = snowflake_user.example_user.name
}

resource "snowflake_grant" "example_user_schema_grant" {
  privilege = "USAGE"
  on        = "SCHEMA ${snowflake_schema.example_schema.name} IN DATABASE ${snowflake_database.example_database.name}"
  to        = snowflake_user.example_user.name
}
