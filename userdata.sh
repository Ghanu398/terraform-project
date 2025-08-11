#!/bin/bash


# === Detect instance tags from EC2 metadata ===
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
SERVER_TYPE=$(aws ec2 describe-tags \
  --region "$REGION" \
  --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=server_type" \
  --query "Tags[0].Value" --output text)

echo "Server type detected: $SERVER_TYPE"

# === Run only if server_type == private ===
if [[ "$SERVER_TYPE" == "private" ]]; then
    echo "Running private server setup..."

    # ---------- Apache + SSL ----------
    yum update -y
    yum install -y httpd
    echo "hello from private server" > /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd

    mkdir -p /etc/ssl/certs /etc/ssl/private
    openssl req -x509 -nodes -days 365 \
      -newkey rsa:2048 \
      -keyout /etc/ssl/private/apache-selfsigned.key \
      -out /etc/ssl/certs/apache-selfsigned.crt \
      -subj "/C=IN/ST=KA/L=BLR/O=MyCompany/OU=Dev/CN=ghanshyam.site"

    yum install -y mod_ssl
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
    systemctl restart httpd

    # ---------- Cron file creation ----------
    mkdir -p /root/files

    cat << 'EOF' > /root/create_file.sh
#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
echo "Cron ran at $(date)" >> /root/cron_test.log
touch /root/files/file_$TIMESTAMP.txt
EOF

    chmod +x /root/create_file.sh
    yum install -y cronie
    systemctl start crond
    systemctl enable crond

    crontab -u root -l 2>/dev/null | grep -q 'create_file.sh' || \
      (crontab -u root -l 2>/dev/null; echo "* * * * * /root/create_file.sh") | crontab -u root -

else
    echo "This is not a private server. Skipping private setup."
fi




# Generate a 2048-bit RSA SSH key pair with no passphrase, saved as ~/.ssh/server1_key
# The comment in the key is "shared-key-for-multiple-clients"
#ssh-keygen -t rsa -b 2048 -q -N "" -f ~/.ssh/server1_key -C "shared-key-for-multiple-clients"

# Download the public key from S3 into the .ssh directory
aws s3 cp s3://cf-templates-185tnga9541qn-us-east-1/server1_key.pub /root/.ssh/

# Download the private key from S3 into the .ssh directory
aws s3 cp s3://cf-templates-185tnga9541qn-us-east-1/server1_key /root/.ssh/

# Set private key permission to read/write for owner only
chmod 600 /root/.ssh/server1_key

# Set public key permission to read-only for owner
chmod 400 /root/.ssh/server1_key.pub

# Upload the public key to the specified S3 bucket
#aws s3 cp /root/.ssh/server1_key.pub s3://cf-templates-185tnga9541qn-us-east-1

# Upload the private key to the specified S3 bucket
#aws s3 cp /root/.ssh/server1_key s3://cf-templates-185tnga9541qn-us-east-1

# removing current empty authorized_keys 
#rm -f /root/.ssh/authorized_keys

# renaming server_key to authorized_keys
cp -f /root/.ssh/server1_key.pub /root/.ssh/authorized_keys

# limitng the permission
chmod 400 /root/.ssh/authorized_keys

# to recreate the server 

mkdir - p test1


