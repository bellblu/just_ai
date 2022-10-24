terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token = "t1.9euelZqWkJDNxsqTns6KmJGay4mWne3rnpWamZeUipbGnZ2YyI6Mks-ayprl8_dUFyll-e8VQUEH_t3z9xRGJmX57xVBQQf-zef1656Vms2WmcqQiYqezI2Uys-Wj86U7_0.Uj2wUbexU7t7MAGpu-0AxVu4QLbyyrZVVlAoX7DxkfxFkQdWsEChFGZRCLw2rOvCA6JfE19D_XU9tBiqeAm-CA"
  cloud_id  = "b1g68gu90plmr77vcmpt"
  folder_id = "b1g1gcrahvffahkcmu0c"
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name = "vm1-app"
  resources {
    cores  = 2
    memory = 2
}
  boot_disk {
    initialize_params {
      image_id = "fd80qm01ah03dkqb14lc"    
    }
  }
  network_interface {
    subnet_id = "e9brb72nm1brc3bili0t"
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "${file("./user.yml")}"
  }
}

output "ip_address_app" {
    value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

resource "yandex_compute_instance" "vm-2" {
  name = "vm1-graf"
  resources {
    cores  = 2
    memory = 2
}
  boot_disk {
    initialize_params {
      image_id = "fd80qm01ah03dkqb14lc"    
    }
  }
  network_interface {
    subnet_id = "e9brb72nm1brc3bili0t"
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "${file("./user.yml")}"
  }
}
output "ip_address_graf" {
    value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
