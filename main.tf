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

resource "aws_glue_job" "glue_job" {

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

