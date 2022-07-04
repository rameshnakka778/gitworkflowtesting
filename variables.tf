variable "my_region" {
  default = "eu-west-1"
}
variable "bucket_name" {
    default  = "aws-glue-assets-576277063358-eu-west-1"
}

variable  "file_name" {
    default   = "glue_shell_prdclsex_test.py"
}

variable "s3_file_path" {
  default = "scripts/"
}

variable "name" {
    description = "Name to be used on all resources as prefix"
    type        = string
    default     = "TEST"
}

variable "num" {
  description = "mention the number of glue jobs to execute"
  type = number
  default = 1
}

variable "enable_glue_job" {
  description = "Enable glue job usage"
  type        = string
  default     = "true"
}

variable "glue_job_name" {
  description = "The name you assign to this job. It must be unique in your account."
  type        = string
  default     = "glue_shell_prdclsex_test"
}

variable "glue_job_role_arn" {
  description = "The ARN of the IAM role associated with this job."
  type        = string
  default     = "arn:aws:iam::576277063358:role/js_roles_js_dpp1_glue_service_role"
}

variable "glue_job_command" {
  description = "(Required) The command of the job."
  type        = list
  default     = [
        {
            #script_location = "s3://aws-glue-assets-576277063358-eu-west-1/scripts/",
            #script_location = "s3://js-s3-aws-glue-bb/scripts/glue_shell_prdclsex_test.py",
            name = "pythonshell",
            python_version = "3"
        }
    ]
}

variable "enable_glue_connection" {
    type    = string
    default = "true"
}

variable "glue_job_description" {
  description = "Description of the job."
  type        = string
  default     = "This is for test fact purpose by Ramesh"
}

variable "glue_job_connections" {
  description = "The list of connections used for this job."
  type        = list
  default     = ["RMS10Connection"]
}

variable "glue_job_additional_connections" {
  description = "The list of connections used for the job."
  type        = list
  default     = []
}

variable "glue_job_default_arguments" {
    description = "The map of default arguments for this job. You can specify arguments here that your own job-execution script consumes, as well as arguments that AWS Glue itself consumes. For information about how to specify and consume your own Job arguments, see the Calling AWS Glue APIs in Python topic in the developer guide. For information about the key-value pairs that AWS Glue consumes to set up your job, see the Special Parameters Used by AWS Glue topic in the developer guide."
    type        = map
    default     = {

        "--job-language"        = "python"
        "--TempDir"             = "s3://aws-glue-assets-576277063358-eu-west-1/temporary/"
        "--bucket_name"         = "aws-glue-target-poc"
        "--class"               = "GlueApp"
        "--extra-py-files"      = "s3://dpp-dev-glue-repository/cx_oracle_jar/cx_Oracle-8.3.0-cp36-cp36m-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl,s3://dpp-dev-glue-repository/glue_python_libs/retl_component-1.0-py3-none-any.whl,s3://dpp-dev-glue-repository/glue_python_libs/python_dotenv-0.20.0-py3-none-any.whl,s3://dpp-dev-glue-repository/glue_python_libs/SQLAlchemy-1.4.35-cp36-cp36m-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl,s3://dpp-dev-glue-repository/glue_python_libs/pandas-1.1.5-cp36-cp36m-manylinux1_x86_64.whl"
        "--extra-files"         = "s3://dpp-dev-glue-repository/cx_oracle_jar/instantclient-basiclite-linuxx64_patched.zip"
        "--config_bucket_name"  = "dpp-dev-glue-repository"
        "--config_file_path"    = "rdw_etl_config/irm/org/"
        "--s3_file_path"        = "RMS10PROMOTION/data/"
        "--s3_filename"         = "prmschdm.txt"
    }
}

variable "glue_job_execution_property" {
    description = "Execution property of the job."
    type        = list
    default     = [
        {
            max_concurrent_runs  = 1
        }
    ]
}

variable "glue_job_glue_version" {
  description = "(Optional) The version of glue to use, for example '1.0'. For information about available versions, see the AWS Glue Release Notes."
  default     = null
}

variable "glue_job_max_capacity" {
  description = "(Optional) The maximum number of AWS Glue data processing units (DPUs) that can be allocated when this job runs. Required when pythonshell is set, accept either 0.0625 or 1.0."
  default     = 0.0625
}

variable "glue_job_max_retries" {
  description = "(Optional) The maximum number of times to retry this job if it fails."
  default     = 0
}

variable "glue_job_notification_property" {
  description = "(Optional) Notification property of the job."
  default     = []
}

variable "glue_job_timeout" {
  description = "(Optional) The job timeout in minutes. The default is 2880 minutes (48 hours)."
  default     = 1
}

variable "glue_job_security_configuration" {
  description = "(Optional) The name of the Security Configuration to be associated with the job."
  default     = null
}

variable "glue_job_worker_type" {
  description = "(Optional) The type of predefined worker that is allocated when a job runs. Accepts a value of Standard, G.1X, or G.2X."
  default     = null
}

variable "glue_job_number_of_workers" {
  description = "(Optional) The number of workers of a defined workerType that are allocated when a job runs."
  default     = null
}
