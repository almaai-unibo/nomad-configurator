# https://developer.hashicorp.com/nomad/tutorials/enterprise/production-deployment-guide-vm-with-consul
data_dir  = "/var/lib/nomad/server/data"

server {
  enabled = true
  bootstrap_expect = 1
}

acl {
  enabled = true
}
