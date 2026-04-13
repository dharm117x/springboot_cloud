#!/bin/bash
# user_data.sh

# Write the cluster name to the config file
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config

# # Ensure the ECS agent is installed and running
# yum install -y ecs-init
# systemctl enable --now ecs
# systemctl start ecs

# Create the logs directory on the host
mkdir -p /var/log/springboot-app
# Give write permissions (chmod 777 is easiest for testing, 
# or chown to the app user for better security)
chmod 777 /var/log/springboot-app