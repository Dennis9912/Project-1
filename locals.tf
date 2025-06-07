locals {
  project_tags = {
    contact      = "amankwah9912@gmail.com"
    application  = "Jupiter"
    project      = "practice-1.0.1"
    environment  = "${terraform.workspace}" # refers to your current workspace (dev, prod, etc)
    creationTime = timestamp()
  }
}