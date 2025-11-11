#!/bin/bash

echo "========================================="
echo "Jenkins Setup Script"
echo "========================================="

# Wait for Jenkins to start
echo "Waiting for Jenkins to start..."
sleep 30

# Get Jenkins initial admin password
if [ -f jenkins_home/secrets/initialAdminPassword ]; then
    echo ""
    echo "========================================="
    echo "Jenkins Initial Admin Password:"
    cat jenkins_home/secrets/initialAdminPassword
    echo ""
    echo "========================================="
fi

echo ""
echo "Jenkins Setup Instructions:"
echo "1. Open http://localhost:8080 in your browser"
echo "2. Enter the initial admin password shown above"
echo "3. Install suggested plugins"
echo "4. Create your first admin user"
echo "5. Install additional plugins:"
echo "   - Docker Pipeline"
echo "   - Kubernetes CLI"
echo "   - Pipeline"
echo "   - Git"
echo "   - Maven Integration"
echo ""
echo "6. Configure Jenkins:"
echo "   - Go to Manage Jenkins > Global Tool Configuration"
echo "   - Add JDK 17 installation"
echo "   - Add Maven 3.9.x installation"
echo "   - Add Docker installation"
echo ""
echo "7. Add Kubernetes credentials:"
echo "   - Copy your kubeconfig file"
echo "   - Go to Manage Jenkins > Manage Credentials"
echo "   - Add Secret file with your kubeconfig"
echo ""
echo "========================================="

