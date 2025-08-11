#!/bin/bash

# Download the public key from S3 into the .ssh directory
aws s3 cp s3://cf-templates-185tnga9541qn-us-east-1/server1_key.pub .ssh/

# Download the private key from S3 into the .ssh directory
aws s3 cp s3://cf-templates-185tnga9541qn-us-east-1/server1_key .ssh/

# Copy the public key to authorized_keys to allow SSH authentication
cp -f server1_key.pub authorized_keys

# Set permissions to read-only for authorized_keys (security requirement)
chmod 400 authorized_keys

# Set permissions to read/write for the private key (security requirement)
chmod 600 server1_key

# Pause for 3 minutes before continuing so that i can configure vpc_peering manually 
sleep 180

# Variables
REMOTE_USER=root
REMOTE_HOST=172.31.20.70 #make sure to update privateip of server1 before running this
REMOTE_DIR=/root/files
LOCAL_DIR=/root/copied_files
KEY_PATH=/root/.ssh/server2_key

# Create local directory
mkdir -p $LOCAL_DIR

# Ensure .ssh directory exists
mkdir -p /root/.ssh

# Optionally add server2_key manually here (if you're embedding the private key via user-data)
# echo "-----BEGIN PRIVATE KEY-----..." > $KEY_PATH
# chmod 400 $KEY_PATH

# Create the file fetching script
cat <<EOF > /root/fetch_files.sh
#!/bin/bash
rsync -avz -e "ssh -i $KEY_PATH -o StrictHostKeyChecking=no" ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/ $LOCAL_DIR/
EOF

# Make it executable
chmod +x /root/fetch_files.sh

# Install rsync and cronie (cron)
yum install -y rsync cronie

# Start and enable cron
systemctl start crond
systemctl enable crond

# Add cron job (if not already added)
crontab -u root -l 2>/dev/null | grep -q 'fetch_files.sh' || \
  (crontab -u root -l 2>/dev/null; echo "*/3 * * * * /root/fetch_files.sh") | crontab -u root -
