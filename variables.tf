variable "region" {
  type = string
  description = "The region for deployment"
  default = "eu-west-1"
}

variable "access_key" {
  type = string
  default = ""
}

variable "secret_key" {
  type = string
  default = ""
}

variable "desired_capacity" {
  default = 3
}
variable "max_size" {
  default = 5
}

variable "min_size" {
  default = 3
}

variable "standard_tags" {
  default = {
    "Owner"
    :
  "Emmanuel Pius-Ogiji"
  ,
"Project": "Tech Test"
}
}
