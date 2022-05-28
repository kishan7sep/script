echo -e "[1] Kubectl\n[2] AWSCLI v2"
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
    fi
    if [ -n "$(command -v apt)" ]; then
        sudo apt update -y
        sudo apt install curl -y
        sudo apt install unzip -y
    fi
    sudo yum remove awscli -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
    export PATH=$PATH:/usr/local/bin/aw
fi        
