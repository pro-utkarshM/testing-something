#!/bin/bash

# Define log file
LOG_FILE="$HOME/find_wallets_output.log"

# Function to append to log file
log_to_file() {
    echo "$1" >> "$LOG_FILE"
}

# Define directories to check (commonly used wallet locations)
SEARCH_DIRS=(
    "$HOME"  # User home directory (for general wallets)
    "/home"  # Other user home directories
    "/root"  # Root home directory
    "/var"   # Some wallets might be stored under /var (for Docker/VM-based wallets)
)

# Define file patterns for various wallets
SEARCH_PATTERNS=(
    "*.dat"        # Common for Bitcoin and other crypto wallets
    "*.json"       # Ethereum keystore files (Geth, Mist)
    "*.wallet"     # Generic wallet files
    "*.key"        # Key files for various wallets
    "*.pem"        # Private key files
    "wallet.dat"   # Bitcoin Core wallet
    "electrum.dat" # Electrum wallet
)

# Function to search for wallet files in a specific directory
search_files() {
    local search_term="$1"
    local directory="$2"
    log_to_file "Searching for '$search_term' in directory: $directory"
    
    find "$directory" -type f -name "$search_term" 2>/dev/null | while read -r file; do
        # Show found wallet files with full path
        log_to_file "Found: $file"
    done
}

# Function to check directories for wallet-related files
search_wallets_in_dirs() {
    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            log_to_file "Searching in directory: $dir"
            for pattern in "${SEARCH_PATTERNS[@]}"; do
                search_files "$pattern" "$dir"
            done
        else
            log_to_file "Directory not found or inaccessible: $dir"
        fi
    done
}

# Main script execution
log_to_file "Starting wallet search..."

# Search for known wallet files
search_wallets_in_dirs

# Searching for Ethereum-specific .json files that match the Ethereum keystore format
log_to_file "Searching for Ethereum keystore files (.json)..."
find "$HOME" -type f -name "*.json" -exec file {} \; 2>/dev/null | grep -i "ethereum" | while read -r result; do
    log_to_file "Ethereum wallet keystore file found: $result"
done

# Finishing up
log_to_file "Wallet search completed!"
