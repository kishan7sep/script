# ROOT COMMAND 

apt-get install -y uidmap

echo "nxautomation:100000:65536" >> /etc/subuid

echo "nxautomation:100000:65536" >> /etc/subgid

# USER

curl -fsSL https://get.docker.com/rootless | sh

export PATH=/home/nxautomation/run/bin:$PATH

export DOCKER_HOST=unix:///run/user/995/docker.sock

sudo loginctl enable-linger nxautomation

# FOR USE PRIVILIAGE PORT TO USER LIKE 80 443
kernel.unprivileged_userns_clone=1
add this to /etc/sysctl.conf
