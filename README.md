# Reth and Lighthouse Node Setup Script

This script automates the installation and setup of the Reth and Lighthouse nodes, configuring them to run as Ethereum execution and consensus clients respectively. It installs required dependencies, downloads the necessary binaries, generates a JWT secret, creates data directories, and starts both nodes.

## Prerequisites

- A Linux-based operating system (e.g., Ubuntu).
- Root or sudo access to install dependencies and configure services.
- Internet access to download the binaries.

---

## Script Overview

1. **Install Dependencies**  
   Updates package lists and installs necessary dependencies:  
   - `curl`
   - `tar`
   - `openssl`

2. **Download Binaries**  
   Downloads the specified versions of Reth and Lighthouse binaries from their official GitHub release pages.  
   - Default Reth version: `v1.1.2`
   - Default Lighthouse version: `v4.2.0`

3. **Extract and Install Binaries**  
   Extracts the binaries and moves them to `/usr/local/bin` for global accessibility.

4. **Generate JWT Secret**  
   Creates a 32-byte JWT secret for communication between the execution and consensus layers.

5. **Set Up Data Directories**  
   Creates the necessary directories for storing data:
   - Reth: `/root/external/reth_data` and `/root/external/reth_data_static`
   - Lighthouse: `/root/lighthouse_data`

6. **Start Nodes**  
   Runs Reth and Lighthouse nodes as background processes:
   - **Reth**: Execution client with HTTP, WebSocket, and authentication enabled.
   - **Lighthouse**: Beacon node with metrics and checkpoint sync enabled.

---

## How to Use

1. Clone or copy the script to your Linux machine  and name  file `node.sh`. 

2. Make the script executable:  
   ```bash
   chmod +x node.sh
   ```
3. Run the script as root or with sudo:
  ```bash
   chmod +x node.sh
  ```
4. The script will log output to:
   - Reth: `/var/log/reth.log`
   - Lighthouse: `/var/log/lighthouse.log`
  

## Customization
- Update the following variables in the script to use different versions:
  ```bash
  RETH_VERSION="v1.1.2"
  LIGHTHOUSE_VERSION="v4.2.0"
  ```
- Adjust the paths for data directories or JWT secret as needed:
  ```bash
  SECRET_DIR="/your/desired/path"
  ```

## Log Files
- Monitor the node logs to ensure proper setup:
   - Reth: `/var/log/reth.log`
   - Lighthouse: `/var/log/lighthouse.log`
