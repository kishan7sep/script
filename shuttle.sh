sudo docker run --name sshuttle -d \
-e SSH_USERNAME=nxautomation \
-e SSH_HOST=20.244.48.236 \
-e SSH_PASSWORD=1234 \
--privileged -e SSH_PORT=8040 \
-e MY_IP=52.90.136.62 --network host kishan7sep/public:sshuttle


export PATH=/home/nxautomation/run/bin:$PATH

export DOCKER_HOST=unix:///run/user/995/docker.sock


docker run -v db:/data/db -d --name mongo -h pritunldb mongo:latest

docker run --privileged -v /etc/localtime:/etc/localtime:ro 
--name pritunl --sysctl net.ipv6.conf.all.disable_ipv6=0 
-h pritunl --link mongo 
-p 8002:80 -p 4430:443 -p 1194:1194 -p 1194:1194/udp 
-p 1195:1195/udp -e TZ=UTC goofball222/pritunl:latest

version: '3'

services:
  mongo:
    image: mongo:latest
    container_name: pritunldb
    hostname: pritunldb
    network_mode: bridge
    volumes:
      - ./db:/data/db

  pritunl:
    image: goofball222/pritunl:latest
    container_name: pritunl
    hostname: pritunl
    depends_on:
        - mongo
    network_mode: bridge
    privileged: true
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=0
    links:
      - mongo
    volumes:
      - /etc/localtime:/etc/localtime:ro
    ports:
      - 80:80
      - 443:443
      - 1194:1194
      - 1194:1194/udp
      - 1195:1195/udp
    environment:
      - TZ=UTC
