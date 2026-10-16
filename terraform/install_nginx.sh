#!/bin/bash
# Runs automatically on the EC2 server the first time it boots.

# Install nginx
apt-get update -y
apt-get install -y nginx

# Install the AWS CLI (used to download the React build from S3)
snap install aws-cli --classic

# Configure nginx to serve a React app.
# "try_files ... /index.html" makes page refreshes work for React routes.
cat > /etc/nginx/sites-available/default <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF

# Temporary page so we can test that nginx works.
# GitHub Actions will replace this with the real React build later.
rm -f /var/www/html/index.nginx-debian.html
echo "<h1>Nginx is working! React app coming soon.</h1>" > /var/www/html/index.html

# Start nginx now and on every reboot
systemctl enable nginx
systemctl restart nginx
