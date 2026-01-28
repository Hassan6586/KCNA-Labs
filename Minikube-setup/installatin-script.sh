#!/bin/bash

################################################################################
# Minikube Installation Script for Ubuntu/Debian Linux
# Description: Automated installation of Minikube and kubectl
# Author: Al Nafi Learning Platform
# Version: 1.0
# Last Updated: January 2026
################################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check CPU cores
    cpu_cores=$(nproc)
    if [ "$cpu_cores" -lt 2 ]; then
        print_warning "System has only $cpu_cores CPU core(s). Minimum 2 cores recommended."
    else
        print_success "CPU cores: $cpu_cores (✓)"
    fi
    
    # Check RAM
    total_ram=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$total_ram" -lt 4 ]; then
        print_warning "System has only ${total_ram}GB RAM. Minimum 4GB recommended."
    else
        print_success "RAM: ${total_ram}GB (✓)"
    fi
    
    # Check disk space
    available_space=$(df -BG / | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ "$available_space" -lt 20 ]; then
        print_warning "Only ${available_space}GB disk space available. Minimum 20GB recommended."
    else
        print_success "Disk space: ${available_space}GB available (✓)"
    fi
}

# Function to update system packages
update_system() {
    print_info "Updating system packages..."
    sudo apt update -qq && sudo apt upgrade -y -qq
    if [ $? -eq 0 ]; then
        print_success "System packages updated successfully"
    else
        print_error "Failed to update system packages"
        exit 1
    fi
}

# Function to install dependencies
install_dependencies() {
    print_info "Installing required dependencies..."
    sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

# Function to check and install Docker
check_docker() {
    print_info "Checking Docker installation..."
    
    if command_exists docker; then
        print_success "Docker is already installed"
        docker_version=$(docker --version)
        print_info "Docker version: $docker_version"
        
        # Check if Docker is running
        if sudo systemctl is-active --quiet docker; then
            print_success "Docker service is running"
        else
            print_warning "Docker is installed but not running. Starting Docker..."
            sudo systemctl start docker
            sudo systemctl enable docker
            print_success "Docker service started"
        fi
    else
        print_warning "Docker is not installed. Installing Docker..."
        install_docker
    fi
    
    # Add current user to docker group
    if groups $USER | grep -q '\bdocker\b'; then
        print_success "User already in docker group"
    else
        print_info "Adding user to docker group..."
        sudo usermod -aG docker $USER
        print_warning "You need to log out and log back in for docker group changes to take effect"
    fi
}

# Function to install Docker
install_docker() {
    print_info "Installing Docker..."
    
    # Remove old versions
    sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null
    
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    
    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    if [ $? -eq 0 ]; then
        print_success "Docker installed successfully"
    else
        print_error "Failed to install Docker"
        exit 1
    fi
}

# Function to install Minikube
install_minikube() {
    print_info "Installing Minikube..."
    
    if command_exists minikube; then
        current_version=$(minikube version --short 2>/dev/null | head -n 1)
        print_warning "Minikube is already installed: $current_version"
        read -p "Do you want to reinstall/update Minikube? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping Minikube installation"
            return 0
        fi
    fi
    
    # Download latest Minikube
    print_info "Downloading Minikube binary..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    
    if [ $? -ne 0 ]; then
        print_error "Failed to download Minikube"
        exit 1
    fi
    
    # Install Minikube
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
    
    # Verify installation
    if command_exists minikube; then
        minikube_version=$(minikube version --short 2>/dev/null | head -n 1)
        print_success "Minikube installed successfully: $minikube_version"
    else
        print_error "Minikube installation failed"
        exit 1
    fi
}

# Function to install kubectl
install_kubectl() {
    print_info "Installing kubectl..."
    
    if command_exists kubectl; then
        current_version=$(kubectl version --client --short 2>/dev/null)
        print_warning "kubectl is already installed: $current_version"
        read -p "Do you want to reinstall/update kubectl? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping kubectl installation"
            return 0
        fi
    fi
    
    # Download latest kubectl
    print_info "Downloading kubectl binary..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    
    if [ $? -ne 0 ]; then
        print_error "Failed to download kubectl"
        exit 1
    fi
    
    # Install kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    
    # Verify installation
    if command_exists kubectl; then
        kubectl_version=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null | head -n 1)
        print_success "kubectl installed successfully: $kubectl_version"
    else
        print_error "kubectl installation failed"
        exit 1
    fi
}

# Function to verify installations
verify_installation() {
    print_info "Verifying installations..."
    echo
    
    # Verify Minikube
    if command_exists minikube; then
        print_success "✓ Minikube: $(minikube version --short 2>/dev/null | head -n 1)"
    else
        print_error "✗ Minikube not found"
    fi
    
    # Verify kubectl
    if command_exists kubectl; then
        print_success "✓ kubectl: $(kubectl version --client --short 2>/dev/null || echo 'Installed')"
    else
        print_error "✗ kubectl not found"
    fi
    
    # Verify Docker
    if command_exists docker; then
        print_success "✓ Docker: $(docker --version)"
    else
        print_error "✗ Docker not found"
    fi
}

# Function to start Minikube (optional)
start_minikube() {
    echo
    read -p "Do you want to start Minikube now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Starting Minikube cluster..."
        minikube start --driver=docker
        
        if [ $? -eq 0 ]; then
            print_success "Minikube cluster started successfully!"
            echo
            print_info "Cluster status:"
            minikube status
        else
            print_error "Failed to start Minikube cluster"
        fi
    else
        print_info "You can start Minikube later using: minikube start --driver=docker"
    fi
}

# Function to display next steps
display_next_steps() {
    echo
    print_success "═══════════════════════════════════════════════════════════"
    print_success "  Minikube Installation Complete!"
    print_success "═══════════════════════════════════════════════════════════"
    echo
    print_info "Next steps:"
    echo "  1. Log out and log back in (if you were added to docker group)"
    echo "  2. Start Minikube: minikube start --driver=docker"
    echo "  3. Check status: minikube status"
    echo "  4. Verify cluster: kubectl get nodes"
    echo "  5. Access dashboard: minikube dashboard"
    echo
    print_info "Useful commands:"
    echo "  • minikube version    - Check Minikube version"
    echo "  • kubectl version     - Check kubectl version"
    echo "  • minikube stop       - Stop the cluster"
    echo "  • minikube delete     - Delete the cluster"
    echo "  • minikube addons list - List available addons"
    echo
}

# Main execution
main() {
    echo
    print_info "═══════════════════════════════════════════════════════════"
    print_info "  Minikube Installation Script"
    print_info "  For Ubuntu/Debian Linux Systems"
    print_info "═══════════════════════════════════════════════════════════"
    echo
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run this script as root or with sudo"
        print_info "The script will prompt for sudo password when needed"
        exit 1
    fi
    
    # Run installation steps
    check_requirements
    echo
    update_system
    echo
    install_dependencies
    echo
    check_docker
    echo
    install_minikube
    echo
    install_kubectl
    echo
    verify_installation
    echo
    start_minikube
    echo
    display_next_steps
}

# Run main function
main
