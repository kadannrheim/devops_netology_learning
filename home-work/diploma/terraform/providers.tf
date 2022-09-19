terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "kadannrbucket"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJEU5hzZFsQ3Eb1pAugSVVG"
    secret_key = "YCO5777***********g_MguZTmUMH8"
    skip_region_validation      = true
    skip_credentials_validation = true
   }
}

provider "yandex" {
  #token    = var.yc_token
  service_account_key_file = "key.json"
  folder_id = var.folder_id
  cloud_id  = var.cloud_id
  zone = var.zone
}