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

// mongodb namespace
resource "kubernetes_deployment" "mongodb" {
  metadata {
    name = "mongodb"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
    labels = {
      app = "mongodb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          image = "mongo"
          name  = "mongodb"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.cm-mongodb.metadata[0].name
            }
          }

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

resource "kubernetes_service" "svc-mongodb" {
  metadata {
    name = "svc-mongodb"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.mongodb.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 27017
      target_port = 27017
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_config_map" "cm-mongodb" {
  metadata {
    name = "cm-mongodb"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
  }

  // improve creds with secret
  data = {
    MONGO_INITDB_ROOT_USERNAME  =  "root-user"
    MONGO_INITDB_ROOT_PASSWORD  = "secret"
    MONGO_INITDB_DATABASE       = "movies"
  }
}

//mongodb UI exposed to public world
// mongodb namespace
resource "kubernetes_deployment" "mongo-express" {
  metadata {
    name = "mongo-express"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
    labels = {
      app = "mongo-express"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        // to fix?
         app = "mongo-express"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongo-express"
        }
      }

      spec {
        container {
          image = "mongo-express"
          name  = "mongo-express"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.cm-mongo-express.metadata[0].name
            }
          }

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

resource "kubernetes_config_map" "cm-mongo-express" {
  metadata {
    name = "cm-mongo-express"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
  }

  // improve creds with secret
  data = {
      ME_CONFIG_BASICAUTH_USERNAME = "test"
      ME_CONFIG_BASICAUTH_PASSWORD = "test"
      ME_CONFIG_MONGODB_ADMINUSERNAME = "root-user"
      ME_CONFIG_MONGODB_ADMINPASSWORD = "secret"
      // service name of mongo (replace)
      ME_CONFIG_MONGODB_SERVER = "${kubernetes_service.svc-mongodb.metadata.0.name}"
  }
}

resource "kubernetes_service" "svc-mongo-express" {
  metadata {
    name = "svc-mongo-express"
    namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.mongo-express.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8081
      target_port = 8081
      node_port   = 32000
    }

    type = "NodePort"
  }
}