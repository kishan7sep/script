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

sudo reboot

NOTE: reboot needed


# pritunl

docker run --rm \
    --name zero \
    -p 8000:80 \
    -p 4430:443 \
    -e MONGO_URI="mongodb://52.90.136.62:27017/pritunl-zero" \
    -e NODE_ID="5b8e11e4610f990034635e98" --network host --privileged -d \
    docker.io/pritunl/pritunl-zero
    
 # chrome
