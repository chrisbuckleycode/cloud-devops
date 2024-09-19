#!/bin/bash
##
## FILE: ubuntu22-bootstrapper.sh
##
## DESCRIPTION: One-by-one installer tool for new Ubuntu 22 server. Use my ansible playbook for a more deterministic
##              solution.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: ubuntu22-bootstrapper.sh
##

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# ANSI color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print in blue
print_blue() {
    echo -e "${BLUE}$1${NC}"
}

# Function to print in green
print_green() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print in red
print_red() {
    echo -e "${RED}$1${NC}"
}

# Function to install Terraform
install_terraform() {
    if validate_terraform; then
        echo -e "${GREEN}Terraform${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    wget https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip
    unzip -o terraform_1.9.5_linux_amd64.zip
    mv terraform /usr/local/bin/
    echo -e "${GREEN}Terraform${NC} ${BLUE}installed.${NC}"
}

# Function to validate Terraform installation
validate_terraform() {
    local result=$(which terraform)
    if [ "$result" = "/usr/local/bin/terraform" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install jq
install_jq() {
    if validate_jq; then
        echo -e "${GREEN}jq${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    apt-get install -y jq
    echo -e "${GREEN}jq${NC} ${BLUE}installed.${NC}"
}

# Function to validate jq installation
validate_jq() {
    local result=$(which jq)
    if [ "$result" = "/usr/bin/jq" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install yq
install_yq() {
    if validate_yq; then
        echo -e "${GREEN}yq${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq
    echo -e "${GREEN}yq${NC} ${BLUE}installed.${NC}"
}

# Function to validate yq installation
validate_yq() {
    local result=$(which yq)
    if [ "$result" = "/usr/bin/yq" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install k9s
install_k9s() {
    if validate_k9s; then
        echo -e "${GREEN}k9s${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    wget https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_Linux_amd64.tar.gz
    tar -xvzf k9s_Linux_amd64.tar.gz
    mv ./k9s /usr/bin/
    echo -e "${GREEN}k9s${NC} ${BLUE}installed.${NC}"
}

# Function to validate k9s installation
validate_k9s() {
    local result=$(which k9s)
    if [ "$result" = "/usr/bin/k9s" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install kubectl
install_kubectl() {
    if validate_kubectl; then
        echo -e "${GREEN}kubectl${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://cdn.dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    echo 'alias k=kubectl' >> ~/.bashrc
    source ~/.bashrc
    echo -e "${GREEN}kubectl${NC} ${BLUE}installed.${NC}"
}

# Function to validate kubectl installation
validate_kubectl() {
    local result=$(which kubectl)
    if [ "$result" = "/usr/local/bin/kubectl" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install helm
install_helm() {
    if validate_helm; then
        echo -e "${GREEN}helm${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    wget https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz
    tar -zxvf helm-v3.15.4-linux-amd64.tar.gz
    mv linux-amd64/helm /usr/local/bin/helm
    echo -e "${GREEN}helm${NC} ${BLUE}installed.${NC}"
}

# Function to validate helm installation
validate_helm() {
    local result=$(which helm)
    if [ "$result" = "/usr/local/bin/helm" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install kind
install_kind() {
    if validate_kind; then
        echo -e "${GREEN}kind${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
    echo -e "${GREEN}kind${NC} ${BLUE}installed.${NC}"
}

# Function to validate kind installation
validate_kind() {
    local result=$(which kind)
    if [ "$result" = "/usr/local/bin/kind" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install awscli
install_awscli() {
    if validate_awscli; then
        echo -e "${GREEN}awscli${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -o awscliv2.zip
    ./aws/install
    echo -e "${GREEN}awscli${NC} ${BLUE}installed.${NC}"
}

# Function to validate awscli installation
validate_awscli() {
    local result=$(which aws)
    if [ "$result" = "/usr/local/bin/aws" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install pip
install_pip() {
    if validate_pip; then
        echo -e "${GREEN}pip${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    apt install -y python3-pip
    echo -e "${GREEN}pip${NC} ${BLUE}installed.${NC}"
}

# Function to validate pip installation
validate_pip() {
    if dpkg -s python3-pip | grep -q "Status: install ok installed"; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install python3.10-venv
install_python_venv() {
    if validate_python_venv; then
        echo -e "${GREEN}python3.10-venv${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    apt install -y python3.10-venv
    echo -e "${GREEN}python3.10-venv${NC} ${BLUE}installed.${NC}"
}

# Function to validate python3.10-venv installation
validate_python_venv() {
    if dpkg -s python3.10-venv | grep -q "Status: install ok installed"; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install golang
install_golang() {
    if validate_golang; then
        echo -e "${GREEN}golang${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
    rm -rf /usr/local/go
    tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin
    go version
    echo -e "${GREEN}golang${NC} ${BLUE}installed.${NC}"
}

# Function to validate golang installation
validate_golang() {
    if [ -f "/usr/local/go/bin/go" ]; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to install unzip
install_unzip() {
    if validate_unzip; then
        echo -e "${GREEN}unzip${NC} ${BLUE}is already installed.${NC}"
        return
    fi
    apt install -y unzip
    echo -e "${GREEN}unzip${NC} ${BLUE}installed.${NC}"
}

# Function to validate unzip installation
validate_unzip() {
    if dpkg -s unzip | grep -q "Status: install ok installed"; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Function to display menu
display_menu() {
    echo "Installer Menu:"
    echo -e "${GREEN}Terraform${NC} [1] [1v]"
    echo -e "${GREEN}jq${NC} [2] [2v]"
    echo -e "${GREEN}yq${NC} [3] [3v]"
    echo -e "${GREEN}k9s${NC} [4] [4v]"
    echo -e "${GREEN}kubectl${NC} [5] [5v]"
    echo -e "${GREEN}helm${NC} [6] [6v]"
    echo -e "${GREEN}kind${NC} [7] [7v]"
    echo -e "${GREEN}awscli${NC} [8] [8v]"
    echo -e "${GREEN}pip${NC} [9] [9v]"
    echo -e "${GREEN}python3.10-venv${NC} [10] [10v]"
    echo -e "${GREEN}golang${NC} [11] [11v]"
    echo -e "${GREEN}unzip${NC} [12] [12v]"
    echo "Exit [q]"
}

# Function to validate and print result
validate_and_print() {
    local program=${1#validate_}
    if $1; then
        echo -e "${GREEN}${program}${NC} ${BLUE}installation validated successfully.${NC}"
    else
        echo -e "${GREEN}${program}${NC} installation validation failed."
    fi
}

# Main loop
while true; do
    display_menu
    read -p "Enter your choice: " choice

    case $choice in
        1) install_terraform ;;
        1v) validate_and_print validate_terraform ;;
        2) install_jq ;;
        2v) validate_and_print validate_jq ;;
        3) install_yq ;;
        3v) validate_and_print validate_yq ;;
        4) install_k9s ;;
        4v) validate_and_print validate_k9s ;;
        5) install_kubectl ;;
        5v) validate_and_print validate_kubectl ;;
        6) install_helm ;;
        6v) validate_and_print validate_helm ;;
        7) install_kind ;;
        7v) validate_and_print validate_kind ;;
        8) install_awscli ;;
        8v) validate_and_print validate_awscli ;;
        9) install_pip ;;
        9v) validate_and_print validate_pip ;;
        10) install_python_venv ;;
        10v) validate_and_print validate_python_venv ;;
        11) install_golang ;;
        11v) validate_and_print validate_golang ;;
        12) install_unzip ;;
        12v) validate_and_print validate_unzip ;;
        q) echo "Exiting..."; exit 0 ;;
        *) print_red "Invalid choice. Please try again." ;;
    esac

    echo # Empty line for readability
done