echo -e "[1] KUBECTL
[2] AWSCLI v2
[3] PRITUNL CLIENT
[4] SSM AGENT
[5] GOOGLE CHROME
[6] VNC VIEWER
[7] VS CODE
[8] PostgresSQL
[9] KONG GATEWAY
[10] JENKINS
[11] OPEN SEARCH
[12] LOGSTASH
"
read number

if [ $number == 1 ]; then
    if [ -n "$(command -v yum)" ]; then 
        sudo yum update -y
        sudo yum install curl -y
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install curl -y
    fi
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi
if [ $number == 2 ]; then
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        sudo yum install curl -y
        sudo yum install unzip -y
        sudo yum remove awscli -y
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install curl -y
        sudo apt install unzip -y
        sudo apt remove awscli -y
    fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
    export PATH=$PATH:/usr/local/bin/aw
fi
if [ $number == 3 ]; then
    if [ -n "$(command -v yum)" ]; then
sudo yum update -y
sudo tee /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Stable Repository
baseurl=https://repo.pritunl.com/stable/yum/amazonlinux/2/
gpgcheck=1
enabled=1
EOF
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
sudo yum install pritunl-client-electron -y
    fi
    if [ -n "$(command -v apt)" ]; then
sudo apt-get update -y
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt jammy main
EOF
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    sudo apt-get update -y
    sudo apt-get install pritunl-client-electron -y
    echo -e "
USEFUL COMMANDS :

sudo pritunl set app.reverse_proxy true
sudo pritunl set app.redirect_server false
sudo pritunl set app.server_ssl false
sudo pritunl set app.server_port 80

FOR NGINX
sudo pritunl set app.reverse_proxy true
sudo pritunl set app.redirect_server false

server {
 
      listen 443;
      server_name nowyousee.storehippo.com;
      error_log /var/log/nginx/vpn.access.log;
 
      ssl on;
          ssl_certificate /etc/nginx/sites-enabled/stores.storehippo.com/stores.storehippo.com_fullchain.txt;
          ssl_certificate_key /etc/nginx/sites-enabled/stores.storehippo.com/stores.storehippo.com_privkey.txt;
          ssl_session_cache  builtin:1000  shared:SSL:10m;
          ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
          ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
          ssl_prefer_server_ciphers on;
 
        location / {
                     proxy_pass http://localhost:4430/;
                     proxy_http_version 1.1;
                     proxy_set_header Upgrade $http_upgrade;
                     proxy_set_header Connection "upgrade";
                     proxy_set_header Host $http_host;
                     proxy_set_header X-Real-IP $remote_addr;
                     proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
                     proxy_set_header X-Forward-Proto http;
                     proxy_set_header X-Nginx-Proxy true;
                     proxy_redirect off;
                   }
 
}


"
    fi
fi       
if [ $number == 4 ]; then
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        test=$(rpm --eval '%{_arch}')
        if [ $test == "x86_64" ]; then 
            arch="amd64"
            sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_$arch/amazon-ssm-agent.rpm
            sudo systemctl start amazon-ssm-agent
            while ! sudo systemctl status amazon-ssm-agent | grep -q "running"; do 
                echo "Service is Not Active Yet"
            done
        fi
        if [ $test == "x86" ]; then 
            arch="386"
            sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_$arch/amazon-ssm-agent.rpm
            sudo start amazon-ssm-agent
        fi
        if [ $test == "arm64" ]; then 
            arch="arm64"
            sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_$arch/amazon-ssm-agent.rpm
            sudo start amazon-ssm-agent
        fi

    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        arch=$(dpkg --print-architecture)
        wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_$arch/amazon-ssm-agent.deb
        sudo dpkg -i amazon-ssm-agent.deb
        sudo systemctl start amazon-ssm-agent
        while ! sudo systemctl status amazon-ssm-agent | grep -q "running"; do 
            echo "Service is Not Active Yet"
        done
    fi
fi
if [ $number == 5 ]; then
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        sudo yum install curl -y
        curl https://intoli.com/install-google-chrome.sh | bash
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        arch=$(dpkg --print-architecture)
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        echo "deb [arch=$arch] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
        sudo apt-get update 
        sudo apt-get install google-chrome-stable
    fi
fi
if [ $number == 6 ]; then
    if [ -n "$(command -v yum)" ]; then
        echo "NOT ADDED FOR THIS OS"
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        arch=$(dpkg --print-architecture)
        if [ $arch == "arm64" ]; then
            wget https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-6.22.315-Linux-x64.deb
            sudo dpkg -i VNC-Viewer-6.22.315-Linux-x64.deb
        else 
            echo "Not Added For This Architecture"
        fi
    fi
fi
if [ $number == 7 ]; then
    if [ -n "$(command -v yum)" ]; then
        echo "NOT ADDED FOR THIS OS"
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install software-properties-common apt-transport-https wget
        wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
        arch=$(dpkg --print-architecture)
        sudo add-apt-repository "deb [arch=$arch] https://packages.microsoft.com/repos/vscode stable main"
        sudo apt install code -y
    fi
fi
if [ $number == 8 ]; then
    if [ -n "$(command -v yum)" ]; then
        echo -e "PostgresSQL Version ? :"
        read version
        sudo yum -y update
        sudo amazon-linux-extras install epel
        sudo  amazon-linux-extras | grep postgre
sudo tee /etc/yum.repos.d/pgdg.repo<<EOF
sudo tee /etc/yum.repos.d/pgdg.repo<<EOF
[pgdg$version]
name=PostgreSQL $version for RHEL/CentOS 7 - x86_64
baseurl=http://download.postgresql.org/pub/repos/yum/$version/redhat/rhel-7-x86_64
enabled=1
gpgcheck=0
EOF
        sudo yum install postgresql$version postgresql$version-server
        sudo /usr/pgsql-$version/bin/postgresql-$version-setup initdb
        sudo systemctl enable --now postgresql-$version
        systemctl status postgresql-$version
        echo -e "TO ACCESS POSTGRESS DATABASSE :
        sudo su - postgres
        psql
        "
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        echo -e "PostgresSQL Version ? :"
        read version
        sudo apt install curl gpg gnupg2 software-properties-common apt-transport-https lsb-release ca-certificates
        curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
        echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
        sudo apt update -y
        sudo apt install postgresql-$version postgresql-client-$version -y
        echo -e "TO ACCESS POSTGRESS DATABASSE :
        sudo su - postgres
        psql
        "
    fi
fi
if [ $number == 9 ]; then
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        curl -Lo kong-enterprise-edition-2.8.1.1.amzn2.noarch.rpm "https://download.konghq.com/gateway-2.x-amazonlinux-2/Packages/k/kong-enterprise-edition-2.8.1.1.amzn2.noarch.rpm"
        sudo yum install kong-enterprise-edition-2.8.1.1.amzn2.noarch.rpm
        echo -e " INSTALL POSTGRESSQL DATABASE 
        # CREATE KONG USER IN POSTGRESS
        CREATE USER kong WITH PASSWORD 'password'; CREATE DATABASE kong OWNER kong;
        # EDIT KONG CONFIG 
        sudo nano /etc/kong/kong.conf.default (like postress password and open admin api at 0.0.0.0)

        # START KONG
        sudo KONG_PASSWORD=kong /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf.default
        sudo /usr/local/bin/kong start -c /etc/kong/kong.conf.default

        # UI FOR KONG
        http://<IP>:8002
        "
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        curl -Lo kong-enterprise-edition-2.8.1.1.all.deb "https://download.konghq.com/gateway-2.x-ubuntu-$(lsb_release -sc)/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_2.8.1.1_all.deb"
        sudo dpkg -i kong-enterprise-edition-2.8.1.1.all.deb
        echo -e " INSTALL POSTGRESSQL DATABASE 
        # CREATE KONG USER IN POSTGRESS
        CREATE USER kong WITH PASSWORD 'password'; CREATE DATABASE kong OWNER kong;
        # EDIT KONG CONFIG 
        sudo nano /etc/kong/kong.conf.default (like postress password and open admin api at 0.0.0.0)

        # START KONG
        sudo KONG_PASSWORD=kong /usr/local/bin/kong migrations bootstrap -c /etc/kong/kong.conf.default
        sudo /usr/local/bin/kong start -c /etc/kong/kong.conf.default

        # UI FOR KONG
        http://<IP>:8002
        "
    fi
fi
if [ $number == 10 ]; then
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        sudo wget -O /etc/yum.repos.d/jenkins.repo \
            https://pkg.jenkins.io/redhat-stable/jenkins.repo
        sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        sudo yum upgrade -y 
        sudo amazon-linux-extras install java-openjdk11 -y
        sudo yum install jenkins -y
        sudo systemctl enable jenkins
        sudo systemctl start jenkins
        sudo systemctl status jenkins
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install openjdk-8-jdk -y
        wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add
        sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
        sudo apt update -y
        sudo apt install jenkins -y
        sudo systemctl start jenkins
        sudo systemctl status jenkins
    fi
fi
if [ $number == 11 ]; then
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        sudo curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/opensearch-2.x.repo -o /etc/yum.repos.d/2.x.repo
        sudo yum install opensearch -y
        sudo systemctl start opensearch.service
        sudo curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/2.x/opensearch-dashboards-2.x.repo -o /etc/yum.repos.d/2.x.repo
        sudo yum install opensearch-dashboards -y
        sudo systemctl start opensearch-dashboards.service
        echo -e "TO ACCESS OPENSEARCH DASHBOARD YOU NEED TO SETUP NGINX VIRTUAL HOST
        server {
            listen 80;
            location / {
                proxy_pass http://localhost:5601;
            }
        }

        IF USING LOGSTASH FOR LOGGING HERE IS SAMPLE 

input {
 file {
   type => "json"
   path => "/home/ec2-user/file4.json"
   start_position => beginning
 }
  #http {
   #  host => "127.0.0.1"
    # port => 8080
  #}
}

filter {
 json {
   source => "message"
 }
 mutate {
  copy => { "_id" => "[@metadata][_id]"}
  remove_field => ["_id"]
 }
}

output {
    opensearch {
        hosts       => ["https://localhost:9200"]
        user        => "admin"
        password    => "admin"
        index       => "logstash-logs-%{+YYYY.MM.dd}"
        ecs_compatibility => disabled
        ssl_certificate_verification => false
    }
}
"
    fi
    if [ -n "$(command -v apt)" ]; then
        echo "NOT ADDED FOR THIS OS"
    fi
fi
if [ $number == 12 ]; then
    echo -e "Logstash Version ? :"
    read version
    if [ -n "$(command -v yum)" ]; then
        sudo yum update -y
        sudo rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
cat << EOF > /etc/yum.repos.d/logstash.repo
[logstash-$version.x]
name=Elastic repository for $version.x packages
baseurl=https://artifacts.elastic.co/packages/$version.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF
        sudo yum install logstash -y
        echo -e "to use logstash  
         /usr/share/logstash/bin/logstash -f /etc/logstash/logstash-sample.conf
        "
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        sudo apt-get install apt-transport-https
        echo "deb https://artifacts.elastic.co/packages/$version.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-$version.x.list
        sudo apt-get update && sudo apt-get install logstash -y
    fi
fi
