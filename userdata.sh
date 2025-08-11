#!/bin/bash

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Add a basic index.html
echo "hello from private server" > /var/www/html/index.html

# Start and enable Apache service
systemctl start httpd
systemctl enable httpd

# Create directories for SSL certificate
mkdir -p /etc/ssl/certs /etc/ssl/private

# Generate a self-signed SSL certificate
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=IN/ST=KA/L=BLR/O=MyCompany/OU=Dev/CN=ghanshyam.site"

# Install mod_ssl to enable SSL in Apache
yum install -y mod_ssl

# Replace the default SSL config with your custom one
cat > /etc/httpd/conf.d/ssl.conf <<EOF
Listen 443 https

<VirtualHost *:443>
    ServerName ghanshyam.site
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/ssl_error.log
    CustomLog /var/log/httpd/ssl_access.log combined
</VirtualHost>
EOF

# Restart Apache to apply SSL config
systemctl restart httpd
