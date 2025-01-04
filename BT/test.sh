#!/bin/bash

# Define directories to check (add Firefox profile directories)
SEARCH_DIRS=(
    "$HOME/.mozilla/firefox"  # Firefox profile directory
    "$HOME/.ethereum"         # Ethereum-related folders
    "/root/.ethereum"         # Root's Ethereum-related folders (if any)
)

# Define file patterns for various wallets
SEARCH_PATTERNS=(
    "*.json"      # Ethereum keystore files (Geth, Mist)
    "*.dat"       # Possible wallet files
    "wallet.dat"  # Bitcoin Core wallet
    "electrum.dat" # Electrum wallet
)

# Function to search for wallet files in a specific directory
search_files() {
    local search_term="$1"
    local directory="$2"
    echo "Searching for '$search_term' in directory: $directory"
    
    find "$directory" -type f -name "$search_term" 2>/dev/null | while read -r file; do
        # Show found wallet files with full path
        echo "Found: $file"
    done
}

# Function to check directories for wallet-related files
search_wallets_in_dirs() {
    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            echo "Searching in directory: $dir"
            for pattern in "${SEARCH_PATTERNS[@]}"; do
                search_files "$pattern" "$dir"
            done
        else
            echo "Directory not found or inaccessible: $dir"
        fi
    done
}

# Main script execution
echo "Starting wallet search..."

# Search for known wallet files
search_wallets_in_dirs

# Searching for Ethereum-specific .json files that match the Ethereum keystore format
echo "Searching for Ethereum keystore files (.json)..."
find "$HOME" -type f -name "*.json" -exec file {} \; 2>/dev/null | grep -i "ethereum" | while read -r result; do
    echo "Ethereum wallet keystore file found: $result"
done

# Finishing up
echo "Wallet search completed!"
