#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check if domains.txt exists
if [ ! -f "domains.txt" ]; then
    echo "Error: domains.txt file not found!"
    exit 1
fi

# Install UFW if not already installed
apt-get update
apt-get install ufw -y

# Reset UFW to default settings
echo "Resetting UFW to default settings..."
ufw --force reset

# Enable UFW
ufw default deny outgoing
ufw default deny incoming

# Allow DNS (necessary for domain resolution)
echo "Adding DNS rules..."
ufw allow out 53/udp
ufw allow out 53/tcp

# Allow established connections
ufw allow in on all from any established

# Allow basic system services
ufw allow out on lo
ufw allow in on lo

# Create a temporary file for storing all resolved IPs
IP_FILE="ip_list.txt"

# Function to resolve domain to IPs and add to temp file
resolve_domain() {
    local domain=$1
    echo "Resolving $domain..."
    
    # Try to resolve both the domain and www.domain
    host $domain 2>/dev/null | grep "has address" | awk '{print $4}' >> "$IP_FILE"
    host "www.$domain" 2>/dev/null | grep "has address" | awk '{print $4}' >> "$IP_FILE"
}

# Process each domain from the file
while IFS= read -r domain || [ -n "$domain" ]; do
    # Skip empty lines and comments
    if [[ -z "$domain" || "$domain" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Remove any whitespace
    domain=$(echo "$domain" | tr -d '[:space:]')
    resolve_domain "$domain"
done < "domains.txt"

# Remove duplicate IPs and empty lines
sort "$IP_FILE" | uniq | sed '/^$/d' > "${IP_FILE}.sorted"

# Add UFW rules for each unique IP
echo "Adding UFW rules for resolved IP addresses..."
while IFS= read -r ip || [ -n "$ip" ]; do
    if [[ -n "$ip" ]]; then
        echo "Adding rules for IP: $ip"
        ufw allow out to $ip port 80 proto tcp
        ufw allow out to $ip port 443 proto tcp
    fi
done < "${IP_FILE}.sorted"

# Clean up temporary files
#rm -f "$IP_FILE" "${IP_FILE}.sorted"

# Enable UFW
echo "y" | ufw enable

echo "==============================================="
echo "Firewall setup complete!"
echo "Only domains listed in domains.txt are accessible."
echo "To verify rules, use: sudo ufw status verbose"
echo "To disable these rules, use: sudo ufw disable"
echo "To add new domains later, add them to domains.txt and run this script again"
echo "==============================================="

# Show current rules
ufw status verbose