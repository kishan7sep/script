sudo docker run --name sshuttle -d \
-e SSH_USERNAME=nxautomation \
-e SSH_HOST=20.244.48.236 \
-e SSH_PASSWORD=1234 \
--privileged -e SSH_PORT=8040 \
-e MY_IP=52.90.136.62 --network host kishan7sep/public:sshuttle





docker run --name db -d --network bridge -v ./db:/data/db mongo

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
