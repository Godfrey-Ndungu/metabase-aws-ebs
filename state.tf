terraform {
  required_version = ">= 1.5.7"
  cloud {
    organization = "peach-cars"
    workspaces {
      name = "metabase"
    }
  }
}
