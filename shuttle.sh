sudo docker run --name sshuttle -d \
-e SSH_USERNAME=nxautomation \
-e SSH_HOST=20.244.48.236 \
-e SSH_PASSWORD=1234 \
--privileged -e SSH_PORT=8040 \
-e MY_IP=52.90.136.62 --network host kishan7sep/public:sshuttle
