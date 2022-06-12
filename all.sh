echo -e "[1] KUBECTL
[2] AWSCLI v2
[3] PRITUNL CLIENT
[4] SSM AGENT
[5] GOOGLE CHROME
[6] VNC VIEWER
[7] VS CODE
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