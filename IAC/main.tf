terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

module "mysql" {
  source = "./mysql"
}

module "wordpress" {
  source                = "./wordpress"
  mysql_container_name  = module.mysql.container_name
  wordpress_network     = module.mysql.wordpress_network
}

module "nginx" {
  source          = "./nginx"
  wordpress_url   = module.wordpress.container_url
  wordpress_network = module.mysql.wordpress_network
}

