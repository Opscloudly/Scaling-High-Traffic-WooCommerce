terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "wordpress" {
  name = "wordpress:latest"
}

resource "docker_container" "wordpress" {
  image = docker_image.wordpress.name
  name  = "wordpress-container"

  env = [
    "WORDPRESS_DB_HOST=${var.mysql_container_name}:3306",
    "WORDPRESS_DB_NAME=wordpress",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_PASSWORD=wordpresspassword"
  ]

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = var.wordpress_network
  }
}

variable "mysql_container_name" {
  type = string
}

variable "wordpress_network" {
  type = string
}

output "container_url" {
  value = "http://${docker_container.wordpress.name}:8080"
}
