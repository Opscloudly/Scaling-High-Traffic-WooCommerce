terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Define the network
resource "docker_network" "wordpress_network" {
  name = "wordpress_network"
}

# MySQL Image
resource "docker_image" "mysql" {
  name = "mysql:5.7"
}

# WordPress Image
resource "docker_image" "wordpress" {
  name = "wordpress:latest"
}

# MySQL Container
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
    name    = docker_network.wordpress_network.name
    aliases = ["mysql-container"]
  }

  healthcheck {
    test        = ["CMD", "mysqladmin", "ping", "-h", "localhost"]
    interval    = "10s"
    retries     = 5
    start_period = "30s"
    timeout     = "10s"
  }
}

# WordPress Container
resource "docker_container" "wordpress" {
  image = docker_image.wordpress.name
  name  = "wordpress-container"

  env = [
    "WORDPRESS_DB_HOST=mysql-container:3306",
    "WORDPRESS_DB_NAME=wordpress",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_PASSWORD=wordpresspassword"
  ]

  ports {
    internal = 80
    external = 8080
  }

  depends_on = [docker_container.mysql]

  networks_advanced {
    name    = docker_network.wordpress_network.name
    aliases = ["wordpress-container"]
  }
}
