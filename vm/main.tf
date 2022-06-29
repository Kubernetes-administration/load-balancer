data "template_file" "instance_startup_script" {
  template = file("${path.module}/templates/gceme.sh.tpl")

  vars = {
    PROXY_PATH = ""
  }
}

resource "google_compute_instance" "default" {
  project                 = var.project
  machine_type            = "n1-standard-1"
  name                    = "default-instance"
  zone                    = "${var.region}-a"
  metadata_startup_script = data.template_file.instance_startup_script.rendered

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}