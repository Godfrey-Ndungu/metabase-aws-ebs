terraform {
  required_version = ">= 1.5.7"
  cloud {
    organization = "{$add-orginization}"
    workspaces {
      name = "metabase"
    }
  }
}
