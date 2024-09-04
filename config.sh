set -e


get_ips_starting_with() {
    PREFIX=$1
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep $PREFIX | sort
}


DATA_CENTER="dc1" # Change this to your data center name
PUBLIC_IP=$(get_ips_starting_with 192 | head -n 1)
PRIVATE_IP=$(get_ips_starting_with 192 | tail -n 1)

echo "Checking if Nomad is installed..."
nomad -v || {
    echo "Nomad is not installed. Please install Nomad first."
    exit 1
}

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

cp -R etc/nomad.d /etc/
./template_apply.py /etc/nomad.d/nomad.hcl.template -d "DATA_CENTER=$DATA_CENTER" > /etc/nomad.d/nomad.hcl
./template_apply.py /etc/nomad.d/addresses.hcl.template -d "HTTP_IP=$PUBLIC_IP" "RPC_IP=$PRIVATE_IP" "SERF_IP=$PRIVATE_IP" > /etc/nomad.d/addresses.hcl
./template_apply.py /etc/nomad.d/client/client.hcl.template -d "SERVERS=\"$PUBLIC_IP\"" > /etc/nomad.d/client/client.hcl
chown -R nomad:nomad /etc/nomad.d

cp -R usr/lib/systemd/system/nomad.service.template usr/lib/systemd/system/nomad-server.service.template
./template_apply.py usr/lib/systemd/system/nomad-server.service.template -d "ROLE=server" "USER=nomad" > usr/lib/systemd/system/nomad-server.service.template

cp -R usr/lib/systemd/system/nomad.service.template usr/lib/systemd/system/nomad-client.service.template
./template_apply.py usr/lib/systemd/system/nomad-client.service.template -d "ROLE=client" "USER=root" > usr/lib/systemd/system/nomad-client.service.template

mkdir -p /var/lib/nomad/server/data
mkdir -p /var/lib/nomad/client/data
chown -R nomad:nomad /var/lib/nomad
