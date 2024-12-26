variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "jenkins_ami" {
  description = "AMI for Jenkins master"
  default = "ami-0e2c8caa4b6378d8c"
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins master"
  default     = "t2.micro"
}

variable "worker_ami" {
  description = "AMI for Jenkins worker"
  default = "ami-0e2c8caa4b6378d8c"
}

variable "worker_instance_type" {
  description = "Instance type for Jenkins workers"
  default     = "t2.micro"
}

variable "worker_count" {
  description = "Number of Jenkins worker nodes"
  default     = 2
}

variable "availability_zone" {
  description = "AWS zone"
  default     = "us-east-1a"
}
