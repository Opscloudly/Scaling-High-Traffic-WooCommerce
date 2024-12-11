terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx-container"

  ports {
    internal = 80
    external = 80
  }

  mounts {
    source    = "${abspath(path.module)}/nginx.conf"
    target    = "/etc/nginx/conf.d/default.conf"
    type      = "bind"
    read_only = true
  }

  networks_advanced {
    name = var.wordpress_network
  }

  depends_on = [var.wordpress_url]
}

variable "wordpress_url" {
  type = string
}

variable "wordpress_network" {
  type = string
}
