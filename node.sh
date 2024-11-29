#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print messages
print_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Update package lists and install dependencies
print_message "Updating package lists and installing dependencies..."
apt-get update
apt-get install -y curl tar openssl

# Define variables for versions
RETH_VERSION="v1.1.2"  # Replace with the latest version if different
LIGHTHOUSE_VERSION="v4.2.0"  # Replace with the latest version if different

# Define download URLs
RETH_URL="https://github.com/paradigmxyz/reth/releases/download/${RETH_VERSION}/reth-${RETH_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
LIGHTHOUSE_URL="https://github.com/sigp/lighthouse/releases/download/${LIGHTHOUSE_VERSION}/lighthouse-${LIGHTHOUSE_VERSION}-x86_64-unknown-linux-gnu.tar.gz"

# Create a directory for downloads
DOWNLOAD_DIR="/root/downloads"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Download Reth
print_message "Downloading Reth ${RETH_VERSION}..."
curl -LO "$RETH_URL"

# Download Lighthouse
print_message "Downloading Lighthouse ${LIGHTHOUSE_VERSION}..."
curl -LO "$LIGHTHOUSE_URL"

# Extract archives
print_message "Extracting Reth..."
tar -xzf "reth-${RETH_VERSION}-x86_64-unknown-linux-gnu.tar.gz"

print_message "Extracting Lighthouse..."
tar -xzf "lighthouse-${LIGHTHOUSE_VERSION}-x86_64-unknown-linux-gnu.tar.gz"

# Move executables to /usr/local/bin
print_message "Moving executables to /usr/local/bin..."
mv reth /usr/local/bin/
mv lighthouse /usr/local/bin/

# Set executable permissions
print_message "Setting executable permissions..."
chmod +x /usr/local/bin/reth
chmod +x /usr/local/bin/lighthouse

# Generate JWT secret
SECRET_DIR="/root/external"
mkdir -p "$SECRET_DIR"
print_message "Generating JWT secret..."
openssl rand -hex 32 > "$SECRET_DIR/jwt.hex"

# Create data directories
RETH_DATA_DIR="/root/external/reth_data"
RETH_STATIC_DATA_DIR="/root/external/reth_data_static"
LIGHTHOUSE_DATA_DIR="/root/lighthouse_data"
mkdir -p "$RETH_DATA_DIR" "$RETH_STATIC_DATA_DIR" "$LIGHTHOUSE_DATA_DIR"

# Run Reth node
print_message "Starting Reth node..."
nohup reth node \
    --full \
    --http \
    --ws \
    --authrpc.jwtsecret "$SECRET_DIR/jwt.hex" \
    --txpool.pending-max-count 100000 \
    --txpool.queued-max-count 100000 \
    --datadir "$RETH_DATA_DIR" \
    --datadir.static-files "$RETH_STATIC_DATA_DIR" \
    --max-outbound-peers 10000 > /var/log/reth.log 2>&1 &

# Run Lighthouse beacon node
print_message "Starting Lighthouse beacon node..."
nohup lighthouse bn \
    --network mainnet \
    --execution-endpoint http://127.0.0.1:8551 \
    --execution-jwt "$SECRET_DIR/jwt.hex" \
    --datadir "$LIGHTHOUSE_DATA_DIR" \
    --http \
    --metrics \
    --checkpoint-sync-url https://sync-mainnet.beaconcha.in > /var/log/lighthouse.log 2>&1 &

print_message "Setup complete. Reth and Lighthouse are running."
