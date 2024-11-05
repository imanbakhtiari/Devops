#!/bin/bash

# Variables
USERNAME="deployer"
SSH_ALLOWED_IP="YOUR_IP_ADDRESS"  # Replace with the specific IP address you want to allow
DOCKER_COMPOSE_SCRIPT="/usr/local/bin/restricted/docker-compose"
DOCKER_GROUP="docker"

# Step 1: Create the deployer user
echo "Creating user '$USERNAME'..."
sudo adduser --disabled-password --gecos "" $USERNAME

# Step 2: Add the user to the docker group
echo "Adding '$USERNAME' to the '$DOCKER_GROUP' group..."
sudo usermod -aG $DOCKER_GROUP $USERNAME

# Step 3: Restrict SSH access to the specific IP
echo "Restricting SSH access for '$USERNAME' to IP: $SSH_ALLOWED_IP..."
SSH_CONFIG="/etc/ssh/sshd_config"
echo -e "\nMatch User $USERNAME\n    AllowUsers $USERNAME@$SSH_ALLOWED_IP" | sudo tee -a $SSH_CONFIG

# Step 4: Create a restricted directory for docker-compose
echo "Creating directory for restricted commands..."
sudo mkdir -p /usr/local/bin/restricted
sudo chmod 755 /usr/local/bin/restricted

# Step 5: Create the docker-compose wrapper script
echo "Creating the docker-compose script..."
echo "#!/bin/bash" | sudo tee $DOCKER_COMPOSE_SCRIPT
echo "exec /usr/local/bin/docker-compose \"\$@\"" | sudo tee -a $DOCKER_COMPOSE_SCRIPT
sudo chmod +x $DOCKER_COMPOSE_SCRIPT

# Step 6: Change the user's shell to rbash
echo "Changing shell for '$USERNAME' to rbash..."
sudo usermod -s /bin/rbash $USERNAME

# Step 7: Set up .bash_profile for the deployer user
echo "Setting up .bash_profile for '$USERNAME'..."
sudo bash -c "echo 'export PATH=/usr/local/bin/restricted:\$PATH' > /home/$USERNAME/.bash_profile"

# Step 8: Restart the SSH service to apply changes
echo "Restarting SSH service..."
sudo systemctl restart ssh

echo "Setup complete! User '$USERNAME' is restricted to running docker-compose from IP: $SSH_ALLOWED_IP"

