#!/bin/bash

# Path to your host.ini file
inventory_file="ansible/host.ini"

# Function to wait for the response from servers
wait_for_response() {
    echo "Waiting for response from the servers..."
    for server_ip in $(grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' "$inventory_file"); do
        until ping -c 1 "$server_ip"; do
            sleep 5
        done
        echo "Server $server_ip is reachable."
    done
}

# Function to apply the Terraform configuration
apply_terraform() {
    echo "Applying Terraform configuration..."
    terraform init
    terraform apply -auto-approve
}

# Function to destroy the Terraform-managed infrastructure
destroy_terraform() {
    echo "Destroying Terraform-managed infrastructure..."
    terraform destroy -auto-approve
}

# Main script
apply_terraform
wait_for_response
destroy_terraform