#!/bin/bash
# Update system (sudo not needed for user data as it runs as root)
yum update -y

# Install NGINX using Amazon Linux Extras
amazon-linux-extras install nginx1 -y

# Create index.html with dynamic content
sudo -u nginx bash -c 'cat > /usr/share/nginx/html/index.html <<"EOL"
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

# Set proper permissions (nginx user owns its content)
chown nginx:nginx /usr/share/nginx/html/index.html
chmod 644 /usr/share/nginx/html/index.html

# Configure NGINX (requires root)
cat > /etc/nginx/conf.d/custom.conf <<'EOL'
server {
    listen       80;
    server_name  _;
    root         /usr/share/nginx/html;
    index        index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
}
EOL

# Start services (root context)
systemctl enable nginx
systemctl restart nginx