docker run --name nginx -p 8000:80 --link chrome --link pritunl -v /home/nxautomation/run/bin/nginx.conf:/etc/nginx/nginx.conf -d nginx

docker network create my

docker run -p 8100:81 -p 8000:80 \
-v /home/nxautomation/run/bin/data:/data \
-v /home/nxautomation/run/bin/letsencrypt:/etc/letsencrypt \
--network my -d jc21/nginx-proxy-manager:latest


docker run --expose 3000 --network my -d --name chrome browserless/chrome

docker run --rm \
    --name pritunl \
    --expose 80 \
    --expose 443 \
    -e MONGO_URI="mongodb://52.90.136.62:27017/pritunl-zero" \
    -e NODE_ID="5b8e11e4610f990034635e98" --network my --privileged -d \
    docker.io/pritunl/pritunl-zero

worker_processes  5;  ## Default: 1
#error_log  logs/error.log;
#pid        logs/nginx.pid;

events {
  worker_connections  4096;  ## Default: 1024
}

stream {
    upstream ssh {
        server chrome:3000;
    }
    server {
        listen 80;
        proxy_pass ssh;
    }
}









sudo docker run --name sshuttle -d \
-e SSH_USERNAME=nxautomation \
-e SSH_HOST=20.244.48.236 \
-e SSH_PASSWORD=1234 \
--privileged -e SSH_PORT=8040 \
-e MY_IP=52.90.136.62 --network host kishan7sep/public:sshuttle


export PATH=/home/nxautomation/run/bin:$PATH

export DOCKER_HOST=unix:///run/user/995/docker.sock


docker run -v db:/data/db -d --name mongo -h pritunldb mongo:latest

docker run --privileged -v /etc/localtime:/etc/localtime:ro \
--name pritunl --sysctl net.ipv6.conf.all.disable_ipv6=0 \
-h pritunl --restart always \
--expose 80 --expose 443 --expose 1194 \
-e TZ=UTC -d -e REVERSE_PROXY=true \
--expose 1194/udp --expose 9700/udp --expose 14567/udp -e MONGODB_URI=mongodb://52.90.136.62:27017/pritunl goofball222/pritunl:latest

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
