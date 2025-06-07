#!/bin/bash
# Update system packages
yum update -y

# Install NGINX
amazon-linux-extras enable nginx1
yum install -y nginx

# Start and enable NGINX
systemctl start nginx
systemctl enable nginx

# Create a simple static web app (HTML)
cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome to Dennis's Web App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f4f6;
            color: #333;
            text-align: center;
            padding: 50px;
        }
        .card {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 DevSecOps Static Web App</h1>
        <p>This web app is running on an EC2 instance provisioned with user data.</p>
        <p>Powered by NGINX on Amazon Linux 2</p>
    </div>
</body>
</html>
EOF

# Open HTTP port in the firewall if using firewalld (generally not enabled by default on Amazon Linux 2)
# firewall-cmd --permanent --add-service=http
# firewall-cmd --reload

# Done!
echo "Web app deployed successfully." > /var/log/webapp-bootstrap.log