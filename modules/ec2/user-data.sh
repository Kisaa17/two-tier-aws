#!/bin/bash
# Update system (sudo not needed for user data as it runs as root)
sudo dnf update -y

# Install NGINX using Amazon Linux Extras
sudo dnf install -y nginx

# Create index.html with dynamic content
sudo bash -c 'cat > /usr/share/nginx/html/index.html <<"EOL"
<html>
<head>
    <title>${server_name}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #2c3e50; }
        .info { background: #f4f4f4; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>${server_name}</h1>
    <div class="info">
        <p><strong>Hostname:</strong> '"$(hostname -f)"'</p>
        <p><strong>AZ:</strong> '"$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"'</p>
        <p><strong>IP:</strong> '"$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"'</p>
        <p><strong>Time:</strong> '"$(date)"'</p>
    </div>
</body>
</html>
EOL'

# Configure NGINX (requires root)
sudo cat <<EOF | tee /usr/share/nginx/html/index.html
<html>
<head>
    <title>Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #2c3e50; }
        .info { background: #f4f4f4; padding: 15px; border-radius: 5px; }
    </style>
</head>
<body>
    <h1>Web Server</h1>
    <div class="info">
        <p><strong>Hostname:</strong> $(hostname -f)</p>
        <p><strong>AZ:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
        <p><strong>IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>
        <p><strong>Time:</strong> $(date)</p>
    </div>
</body>
</html>
EOF


# Start services (root context)
sudo systemctl enable nginx
sudo systemctl restart nginx