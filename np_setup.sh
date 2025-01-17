#!/bin/bash

# 1. Install Git if it's not already installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install git -y
else
    echo "Git is already installed."
fi

# 2. Remove the nodepay folder if it already exists
REPO_DIR="nodepay"
if [ -d "$REPO_DIR" ]; then
    echo "Removing existing $REPO_DIR directory..."
    rm -rf $REPO_DIR
fi

# 3. Clone the Python script from Git repository
GIT_REPO_URL="https://github.com/NodeFarmer/nodepay.git"
PYTHON_FILE="nodepay.py"
git clone $GIT_REPO_URL || { echo "Failed to clone Git repository"; exit 1; }

# 4. Install Python if it's not already installed
if ! command -v python3 &>/dev/null; then
    echo "Python is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install python3 -y
else
    echo "Python is already installed."
fi

# 5. Install required dependencies
sudo apt-get install python3-pip -y
pip3 install asyncio requests loguru websockets websockets-proxy requests[socks] PySocks cloudscraper

# 6. Prompt for NP_TOKEN
read -p "Please enter your NP_TOKEN: " np_token

# 7. Prompt for list of proxies
echo "Please enter your list of proxies, one per line. Finish input with Ctrl+D:"
proxies=$(cat)

# 8. Ask if the user will use HTTP/HTTPS or SOCKS proxy
echo "Select the proxy type:"
echo "1. HTTP/HTTPS"
echo "2. SOCKS"
read -p "Enter the number corresponding to your proxy type: " proxy_choice

if [ "$proxy_choice" -eq 1 ]; then
    proxy_type="http"
elif [ "$proxy_choice" -eq 2 ]; then
    proxy_type="socks"
else
    echo "Invalid choice. Exiting..."
    exit 1
fi

# 9. Save the NP_TOKEN and proxies to configuration files inside the cloned repository
echo $np_token > $REPO_DIR/token.txt
echo "$proxies" > $REPO_DIR/proxies.txt

# 10. Write proxy type to proxy-config.txt
echo "$proxy_type" > $REPO_DIR/proxy-config.txt

echo "Configuration completed. You can now run the Python script with: python3 $REPO_DIR/$PYTHON_FILE"
