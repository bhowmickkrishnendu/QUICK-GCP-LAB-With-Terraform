output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "frontend_lb_ip" {
  value = kubernetes_service.frontend.status[0].load_balancer[0].ingress[0].ip
}
