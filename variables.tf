variable "region" {
  type        = string
  description = "The region for deployment"
  default     = "eu-west-1"
}

variable "access_key" {
  type        = string
  description = "The AWS access key to access the AWS account"
  default     = ""
}

variable "secret_key" {
  type        = string
  description = "The AWS secret key to access the AWS account"
  default     = ""
}

variable "upper_cpu_threshold" {
  description = "The value of average CPU Utilization (in %) which triggers a scale out"
  default     = "60"
}

variable "lower_cpu_threshold" {
  description = "The value of average CPU Utilization (in %) which triggers a scale out"
  default     = "40"
}

variable "desired_capacity" {
  description = "The desired number of instances serving traffic behind the ASG and ELB"
  default     = 3
}
variable "max_size" {
  description = "The maximum number of instances serving traffic behind the ASG and ELB"
  default     = 5
}

variable "min_size" {
  description = "The minimum number of instances serving traffic behind the ASG and ELB"
  default     = 1
}

variable "standard_tags" {
  default = {
    "Owner" : "Emmanuel Pius-Ogiji",
    "Project" : "Tech Test"
  }
}
