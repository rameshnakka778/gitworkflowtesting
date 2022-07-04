locals {

  ou_config = yamldecode(file("Glue.yaml"))

  expanded_names = flatten([
      for key1, value1 in local.ou_config.AWS_GLUE_JOBS: [
          for key2, value2 in value1: [
              for key3, value3 in value2: [
                  for key4, value4 in value3: [
                      for key5, value5 in value4: [
                          value5
                      ]
                  ]
              ]
          ]
      ]
  ])

}

module "glue_jobs_deployments" {

    for_each = {for key, val in local.expanded_names: key => val}

    source                      = "./modules/glue_jobs_deployment"
    s3_file_path                = "scripts/${each.value.File_name}"
    bucket_name                 = each.value.Bucket_name
    file_name                   = each.value.File_name
    glue_job_name               = each.value.Name
    glue_job_role_arn           = each.value.Role
    glue_job_description        = each.value.Description
    glue_job_connections        = each.value.Connections
    glue_job_default_arguments  = each.value.DefaultArguments
    glue_job_max_capacity       = each.value.MaxCapacity
    glue_job_max_retries        = each.value.MaxRetries
    glue_job_timeout            = each.value.Timeout
    glue_job_execution_property = [
        {
            max_concurrent_runs  = var.max_concurrent_runs
        }
    ]
}

# module "glue_connection_vpc" {

#     source                      = "./modules/AWS_GLUE_CONNECTION"
#     create = var.create_connection
#     name = var.conn_name
#     url  = var.conn_url
#     user = var.conn_user
#     pass = var.conn_pass
#     sg_ids = var.conn_sg_ids
#     subnet = var.conn_subnet
#     azs    = var.conn_azs
#     type        = var.conn_type
#     catalog_id  = var.conn_catalog_id
#     description = var.conn_description
#     criteria    = var.conn_criteria
# }

# module "glue_database" {

#   source = "./modules/glue_database"
#   create = var.create_database
#   name = var.db_name
#   description  = var.db_description
#   catalog      = var.db_catalog_id
#   location_uri = var.db_location_uri
#   params       = var.db_params
# }

# module "glue_crawler" {

#   source = "./modules/glue_crawler"
#   create = var.create_crawler
#   name = var.crawl_name
#   db   = var.crawl_database
#   role = var.crawl_role
#   schedule     = var.crawl_schedule
#   table_prefix = var.crawl_table_prefix
#   s3_path      = var.crawl_s3_path
# }

# module "glue_job_trigger" {

#   source = "./modules/glue_job_trigger"
#   create = var.create_trigger
#   name     = var.trigger_name
#   schedule = var.trigger_schedule
#   job_name = var.trigger_job
#   trigger_type        = var.trigger_type
#   enabled     = var.trigger_enabled
#   description = var.trigger_description
#   arguments   = var.trigger_arguments
#   timeout     = var.trigger_timeout
# }
# end of the program