# https://developer.hashicorp.com/nomad/docs/drivers/docker#plugin-options

plugin "docker" {
  config {
    endpoint = "unix:///var/run/docker.sock"

    # auth {
    #   config = "/etc/docker-auth.json"
    #   helper = "ecr-login"
    # }

    extra_labels = ["job_name", "job_id", "task_group_name", "task_name", "namespace", "node_name", "node_id"]

    gc {
      image       = true
      image_delay = "3m"
      container   = true

      dangling_containers {
        enabled        = true
        dry_run        = false
        period         = "5m"
        creation_grace = "5m"
      }
    }

    volumes {
      enabled      = true
      selinuxlabel = "z"
    }

    allow_privileged = true
    allow_caps       = ["chown", "net_raw"]
  }
}
