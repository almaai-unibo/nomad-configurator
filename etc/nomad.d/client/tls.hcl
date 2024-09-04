# https://developer.hashicorp.com/nomad/tutorials/transport-security/security-enable-tls
tls {
  ca_file   = "../tls/nomad-agent-ca.pem"
  cert_file = "../tls/global-client-nomad.pem"
  key_file  = "../tls/global-client-nomad-key.pem"
}
