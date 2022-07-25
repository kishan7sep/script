# ROOT COMMANDS

sudo su

sudo curl -o /etc/yum.repos.d/vbatts-shadow-utils-newxidmap-epel-7.repo https://copr.fedorainfracloud.org/coprs/vbatts/shadow-utils-newxidmap/repo/epel-7/vbatts-shadow-utils-newxidmap-epel-7.repo

sudo yum install -y shadow-utils46-newxidmap

sudo useradd kishan

echo "kishan:100000:65536" >> /etc/subuid

echo "kishan:100000:65536" >> /etc/subgid

sudo su - kishan

# USER COMMAND

curl -fsSL https://get.docker.com/rootless | sh

export XDG_RUNTIME_DIR=/home/kishan/.docker/run

export PATH=/home/kishan/bin:$PATH

export DOCKER_HOST=unix:///home/kishan/.docker/run/docker.sock
