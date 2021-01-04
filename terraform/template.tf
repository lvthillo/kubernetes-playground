provider "kubernetes" {
  config_context = "kubernetes-admin@kubernetes"
}

resource "kubernetes_namespace" "demo-namespace" {
  /*labels = {
      app = "movie"
  }*/
  metadata {
    name = "my-demo-namespace"
  }
}

resource "kubernetes_deployment" "mongodb" {
  metadata {
    name = "mongodb"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
    labels = {
      res = "mongodb"
      app = "movie"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        res = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          res = "mongodb"
        }
      }

      spec {
        container {
          image = "mongo"
          name  = "mongodb"

          /*resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }*/

          /*liveness_probe {
            http_get {
              path = "/nginx_status"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }*/
        }
      }
    }
  }
}