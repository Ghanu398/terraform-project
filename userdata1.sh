#!/bin/bash

# Download the public key from S3 into the .ssh directory
aws s3 cp s3://cf-templates-185tnga9541qn-us-east-1/server1_key.pub /root/.ssh/

# Download the private key from S3 into the .ssh directory
aws s3 cp s3://cf-templates-185tnga9541qn-us-east-1/server1_key /root/.ssh/

# Set public key permission to read-only for owner
chmod 400 /root/.ssh/server1_key.pub

# Copy the public key to authorized_keys to allow SSH authentication
cp -f /root/.ssh/server1_key.pub /root/.ssh/authorized_keys

# Set permissions to read-only for authorized_keys (security requirement)
chmod 400 /root/.ssh/authorized_keys

# Set permissions to read/write for the private key (security requirement)
chmod 600 /root/.ssh/server1_key

# Pause for 3 minutes before continuing so that i can configure vpc_peering manually 
sleep 180



# === Detect instance metadata ===
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
SERVER_TYPE=$(aws ec2 describe-tags \
  --region "$REGION" \
  --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=server_type" \
  --query "Tags[0].Value" --output text)

echo "Server type: $SERVER_TYPE"
echo "Region: $REGION"

# Only run if this is the second private server in us-east-2
if [[ "$SERVER_TYPE" == "private" ]]; then
    echo "Setting up fetch_files cron for second private server..."

    REMOTE_USER=root
    REMOTE_HOST=$(aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=private-server-Vpc-us-east-1" "Name=instance-state-name,Values=running" \
      --query "Reservations[0].Instances[0].PrivateIpAddress" \
      --output text \
      --region us-east-1)

    echo "Detected Server 1 Private IP: $REMOTE_HOST"

    REMOTE_DIR=/root/files
    LOCAL_DIR=/root/copied_files
    KEY_PATH=/root/.ssh/server2_key

    mkdir -p $LOCAL_DIR
    mkdir -p /root/.ssh

    # If embedding private key via user-data (uncomment and replace below)
    # echo "-----BEGIN PRIVATE KEY-----..." > $KEY_PATH
    # chmod 400 $KEY_PATH

    cat <<EOF > /root/fetch_files.sh
#!/bin/bash
rsync -avz -e "ssh -i $KEY_PATH -o StrictHostKeyChecking=no" ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/ $LOCAL_DIR/
EOF
    chmod +x /root/fetch_files.sh

    yum install -y rsync cronie
    systemctl start crond
    systemctl enable crond

    crontab -u root -l 2>/dev/null | grep -q 'fetch_files.sh' || \
      (crontab -u root -l 2>/dev/null; echo "*/3 * * * * /root/fetch_files.sh") | crontab -u root -
fi

