terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "mysql" {
  name = "mysql:5.7"
}

resource "docker_network" "wordpress_network" {
  name = "wordpress_network"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.name
  name  = "mysql-container"

  env = [
    "MYSQL_ROOT_PASSWORD=rootpassword",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=wordpresspassword"
  ]

  ports {
    internal = 3306
    external = 3306
  }

  networks_advanced {
    name = docker_network.wordpress_network.name
  }
}

output "container_name" {
  value = docker_container.mysql.name
}

output "wordpress_network" {
  value = docker_network.wordpress_network.name
}
