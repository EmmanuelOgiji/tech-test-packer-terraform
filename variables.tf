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

variable "subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for subnet creation. Used to give multiAZ resilience"
  default     = ["10.0.0.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "upper_cpu_threshold" {
  description = "The value of average CPU Utilization (in %) which triggers a scale out"
  default     = "60"
}

variable "alarm_evaluation_periods" {
  description = "The number of periods over which Average CPU Utilization is compared to the specified threshold"
  default     = "2"
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

variable "alarm_period" {
  description = "The period in seconds over which the specified statistic (average in this case) is applied."
  default     = "60"
}

variable "scale_down_cooldown" {
  description = "The number of seconds between scaling in activities"
  default     = 60
}

variable "scale_up_cooldown" {
  description = "The number of seconds between scaling in activities"
  default     = 120
}

variable "standard_tags" {
  default = {
    "Owner" : "Emmanuel Pius-Ogiji",
    "Project" : "Tech Test"
  }
}
