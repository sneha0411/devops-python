terraform {
  required_version = ">= 1.5"
}

terraform {
  backend "gcs" {
    bucket  = "tf-state-project-b9c15744"
    prefix  = "gke/jenkins-cluster"
  }
}

