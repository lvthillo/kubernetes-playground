provider "kubernetes" {
  config_context = "kubernetes-admin@kubernetes"
}

resource "kubernetes_namespace" "demo-namespace" {
  metadata {
    name = "my-demo-namespace"
  }
}

// mongodb
resource "kubernetes_deployment" "mongodb" {
  metadata {
    name = "mongodb"
    namespace = kubernetes_namespace.demo-namespace.metadata[0].name
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
            secret_ref {
              name = kubernetes_secret.scrt-mongodb.metadata[0].name
            }
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.cm-mongodb.metadata[0].name  
            }
          }

          resources {
            limits {
              cpu    = "500m"
              memory = "1Gi"
            }
            requests {
              cpu    = "150m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            exec {
              command =  ["bash", "-c", "mongo -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --eval db.adminCommand(\"ping\")"]
            }
            initial_delay_seconds = 3
            period_seconds        = 1
          }
        }
      }
    }
  }
}

// mongodb svc
resource "kubernetes_service" "svc-mongodb" {
  metadata {
    name = "svc-mongodb"
    namespace = kubernetes_namespace.demo-namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.mongodb.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 27017
      target_port = 27017
    }
    type = "ClusterIP"
  }
}

// mongodb configmap
resource "kubernetes_config_map" "cm-mongodb" {
  metadata {
    name = "cm-mongodb"
    namespace = kubernetes_namespace.demo-namespace.metadata.0.name
  }

  // improve creds with secret
  data = {
    MONGO_INITDB_DATABASE = "movies"
  }
}

// monbodb secret
resource "kubernetes_secret" "scrt-mongodb" {
  metadata {
    name = "mongodb-creds"
    namespace = kubernetes_namespace.demo-namespace.metadata.0.name
  }

  data = {
    MONGO_INITDB_ROOT_USERNAME = "root-user"
    MONGO_INITDB_ROOT_PASSWORD = "secret"
  }

  type = "opaque"
}

# //mongo express deployment
# //mongo-express UI exposed to public world
# resource "kubernetes_deployment" "mongo-express" {
#   metadata {
#     name = "mongo-express"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#     labels = {
#       app = "mongo-express"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#          app = "mongo-express"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "mongo-express"
#         }
#       }

#       spec {
#         container {
#           image = "mongo-express"
#           name  = "mongo-express"

#           env_from {
#             config_map_ref {
#               name = kubernetes_config_map.cm-mongo-express.metadata[0].name
#             }
#           }

#           /*resources {
#             limits {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }*/

#           /*liveness_probe {
#             http_get {
#               path = "/nginx_status"
#               port = 80

#               http_header {
#                 name  = "X-Custom-Header"
#                 value = "Awesome"
#               }
#             }

#             initial_delay_seconds = 3
#             period_seconds        = 3
#           }*/
#         }
#       }
#     }
#   }
# }

# // mongo express configmap
# resource "kubernetes_config_map" "cm-mongo-express" {
#   metadata {
#     name = "cm-mongo-express"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#   }

#   // improve creds with secret
#   data = {
#       ME_CONFIG_BASICAUTH_USERNAME = "test"
#       ME_CONFIG_BASICAUTH_PASSWORD = "test"
#       ME_CONFIG_MONGODB_ADMINUSERNAME = "root-user"
#       ME_CONFIG_MONGODB_ADMINPASSWORD = "secret"
#       ME_CONFIG_MONGODB_SERVER = "${kubernetes_service.svc-mongodb.metadata.0.name}"
#   }
# }

# //mongo express svc (exposed publicly)
# resource "kubernetes_service" "svc-mongo-express" {
#   metadata {
#     name = "svc-mongo-express"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#   }
#   spec {
#     selector = {
#       app = "${kubernetes_deployment.mongo-express.metadata.0.labels.app}"
#     }
#     session_affinity = "ClientIP"
#     port {
#       port        = 8081
#       target_port = 8081
#       node_port   = 32000
#     }

#     type = "NodePort"
#   }
# }

# # Go backend deployment
# resource "kubernetes_deployment" "backend" {
#   metadata {
#     name = "backend"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#     labels = {
#       app = "backend"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#          app = "backend"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "backend"
#         }
#       }

#       spec {
#         container {
#           image = "lvthillo/movie-backend"
#           name  = "backend"

#           env_from {
#             config_map_ref {
#               name = kubernetes_config_map.cm-backend.metadata[0].name
#             }
#           }

#           /*resources {
#             limits {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }*/

#           /*liveness_probe {
#             http_get {
#               path = "/nginx_status"
#               port = 80

#               http_header {
#                 name  = "X-Custom-Header"
#                 value = "Awesome"
#               }
#             }

#             initial_delay_seconds = 3
#             period_seconds        = 3
#           }*/
#         }
#       }
#     }
#   }
# }

# # go backend configmap
# resource "kubernetes_config_map" "cm-backend" {
#   metadata {
#     name = "cm-backend"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#   }

#   // improve creds with secret
#   data = {
#       MONGODB_USERNAME = "root-user"
#       MONGODB_PASSWORD = "secret"
#       MONGODB_ENDPOINT = "${kubernetes_service.svc-mongodb.metadata.0.name}:${kubernetes_service.svc-mongodb.spec.0.port.0.port}"
#   }
# }

# # go backend svc
# # exposed publicly because angular is ran from the brower (to connect)
# resource "kubernetes_service" "svc-backend" {
#   metadata {
#     name = "svc-backend"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#   }
#   spec {
#     selector = {
#       app = "${kubernetes_deployment.backend.metadata.0.labels.app}"
#     }
#     session_affinity = "ClientIP"
#     port {
#       port        = 8080
#       target_port = 8080
#       node_port   = 32001
#     }

#     type = "NodePort"
#   }
# }

# # frontend angular deployment
# resource "kubernetes_deployment" "frontend" {
#   metadata {
#     name = "frontend"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#     labels = {
#       app = "frontend"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#          app = "frontend"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "frontend"
#         }
#       }

#       spec {
#         container {
#           image = "lvthillo/movie-frontend"
#           name  = "frontend"

#           /*resources {
#             limits {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }*/

#           /*liveness_probe {
#             http_get {
#               path = "/nginx_status"
#               port = 80

#               http_header {
#                 name  = "X-Custom-Header"
#                 value = "Awesome"
#               }
#             }

#             initial_delay_seconds = 3
#             period_seconds        = 3
#           }*/
#         }
#       }
#     }
#   }
# }

# # frontend svc (exposed)
# resource "kubernetes_service" "svc-frontend" {
#   metadata {
#     name = "svc-frontend"
#     namespace = "${kubernetes_namespace.demo-namespace.metadata.0.name}"
#   }
#   spec {
#     selector = {
#       app = "${kubernetes_deployment.frontend.metadata.0.labels.app}"
#     }
#     session_affinity = "ClientIP"
#     port {
#       port        = 80
#       target_port = 80
#       node_port   = 32002
#     }

#     type = "NodePort"
#   }
# }
