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
#!/bin/bash

# Generate a 2048-bit RSA SSH key pair with no passphrase, saved as ~/.ssh/server1_key
# The comment in the key is "shared-key-for-multiple-clients"
ssh-keygen -t rsa -b 2048 -q -N "" -f ~/.ssh/server1_key -C "shared-key-for-multiple-clients"

# Set private key permission to read/write for owner only
chmod 600 server1_key

# Set public key permission to read-only for owner
chmod 400 server1_key.pub

# Upload the public key to the specified S3 bucket
aws s3 cp .ssh/server1_key.pub s3://cf-templates-185tnga9541qn-us-east-1

# Upload the private key to the specified S3 bucket
aws s3 cp .ssh/server1_key s3://cf-templates-185tnga9541qn-us-east-1

# removing current empty authorized_keys 
rm -f .ssh/authorized_keys

# renaming server_key to authorized_keys
cp -f .ssh/server1_key.pub .ssh/authorized_keys

# limitng the permission
chmod 400 authorized_keys

# Set up directories and script
mkdir -p /root/files

# Create the file creation script
cat << 'EOF' > /root/create_file.sh
#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
echo "Cron ran at $(date)" >> /root/cron_test.log
touch /root/files/file_$TIMESTAMP.txt
EOF

# Make the script executable
chmod +x /root/create_file.sh

# Install cron (cronie) if not already installed
yum install -y cronie

# Start and enable the cron service
systemctl start crond
systemctl enable crond

# Add cron job (only if it doesn't exist)
crontab -u root -l 2>/dev/null | grep -q 'create_file.sh' || \
  (crontab -u root -l 2>/dev/null; echo "* * * * * /root/create_file.sh") | crontab -u root -

