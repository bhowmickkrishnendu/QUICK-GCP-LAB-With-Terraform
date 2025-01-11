provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}

# ----------- GKE Cluster -----------
resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.zone
  initial_node_count = 3

  node_config {
    machine_type = "e2-medium"
  }
}

# ----------- Enable APIs -----------
resource "google_project_service" "cloudbuild" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
}

# ----------- Cloud Build builds -----------
resource "google_cloudbuild_trigger" "monolith_build" {
  name = "${var.monolith_name}-trigger"

  github {
    owner = "googlecodelabs"
    name  = "monolith-to-microservices"
    push {
      branch = ".*"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/${var.project_id}/${var.monolith_name}:1.0.0", "."]
    }
    images = ["gcr.io/${var.project_id}/${var.monolith_name}:1.0.0"]
  }
}

resource "google_cloudbuild_trigger" "orders_build" {
  name = "${var.orders_name}-trigger"

  github {
    owner = "googlecodelabs"
    name  = "monolith-to-microservices"
    push {
      branch = ".*"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      dir  = "microservices/src/orders"
      args = ["build", "-t", "gcr.io/${var.project_id}/${var.orders_name}:1.0.0", "."]
    }
    images = ["gcr.io/${var.project_id}/${var.orders_name}:1.0.0"]
  }
}

resource "google_cloudbuild_trigger" "products_build" {
  name = "${var.products_name}-trigger"

  github {
    owner = "googlecodelabs"
    name  = "monolith-to-microservices"
    push {
      branch = ".*"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      dir  = "microservices/src/products"
      args = ["build", "-t", "gcr.io/${var.project_id}/${var.products_name}:1.0.0", "."]
    }
    images = ["gcr.io/${var.project_id}/${var.products_name}:1.0.0"]
  }
}

resource "google_cloudbuild_trigger" "frontend_build" {
  name = "${var.frontend_name}-trigger"

  github {
    owner = "googlecodelabs"
    name  = "monolith-to-microservices"
    push {
      branch = ".*"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      dir  = "microservices/src/frontend"
      args = ["build", "-t", "gcr.io/${var.project_id}/${var.frontend_name}:1.0.0", "."]
    }
    images = ["gcr.io/${var.project_id}/${var.frontend_name}:1.0.0"]
  }
}

# ----------- Kubernetes Deployments & Services -----------

# MONOLITH
resource "kubernetes_deployment" "monolith" {
  metadata {
    name = var.monolith_name
    labels = {
      app = var.monolith_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.monolith_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.monolith_name
        }
      }
      spec {
        container {
          image = "gcr.io/${var.project_id}/${var.monolith_name}:1.0.0"
          name  = var.monolith_name
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "monolith" {
  metadata {
    name = var.monolith_name
  }
  spec {
    selector = {
      app = var.monolith_name
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

# ORDERS
resource "kubernetes_deployment" "orders" {
  metadata {
    name = var.orders_name
    labels = {
      app = var.orders_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.orders_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.orders_name
        }
      }
      spec {
        container {
          image = "gcr.io/${var.project_id}/${var.orders_name}:1.0.0"
          name  = var.orders_name
          port {
            container_port = 8081
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "orders" {
  metadata {
    name = var.orders_name
  }
  spec {
    selector = {
      app = var.orders_name
    }
    port {
      port        = 80
      target_port = 8081
    }
    type = "LoadBalancer"
  }
}

# PRODUCTS
resource "kubernetes_deployment" "products" {
  metadata {
    name = var.products_name
    labels = {
      app = var.products_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.products_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.products_name
        }
      }
      spec {
        container {
          image = "gcr.io/${var.project_id}/${var.products_name}:1.0.0"
          name  = var.products_name
          port {
            container_port = 8082
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "products" {
  metadata {
    name = var.products_name
  }
  spec {
    selector = {
      app = var.products_name
    }
    port {
      port        = 80
      target_port = 8082
    }
    type = "LoadBalancer"
  }
}

# FRONTEND
resource "kubernetes_deployment" "frontend" {
  metadata {
    name = var.frontend_name
    labels = {
      app = var.frontend_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.frontend_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.frontend_name
        }
      }
      spec {
        container {
          image = "gcr.io/${var.project_id}/${var.frontend_name}:1.0.0"
          name  = var.frontend_name
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = var.frontend_name
  }
  spec {
    selector = {
      app = var.frontend_name
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
