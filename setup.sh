#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# Treat unset variables as an error and exit.
# Exit on pipeline failures.
set -euo pipefail

# --- Helper Functions ---

# Function to print messages
msg() {
  echo -e "\n▶ ${1}"
}

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to install a single package with a spinner
install_package() {
    local pkg=$1
    shift
    local install_command=($@)

    local message="Installing $pkg"
    local log_file
    log_file=$(mktemp)
    local spin='|/-\'
    local i=0

    # Start installation in the background
    "${install_command[@]}" "$pkg" >"$log_file" 2>&1 & 
    local pid=$!

    # Spinner loop
    while true; do
        i=$(( (i+1) % 4 ))
        printf "\r  %c %s" "${spin:$i:1}" "$message"

        if ! kill -0 $pid 2>/dev/null;
then
            break
        fi

        sleep 0.1
    done

    wait $pid
    local exit_code=$?

    # Clear line and print result
    printf "\r%*s\r" "$(tput cols)" ""

    if [ $exit_code -eq 0 ]; then
        if grep -q "already installed" "$log_file"; then
            printf "  ✔ %s (already installed)\n" "$pkg"
        else
            printf "  ✔ %s installed\n" "$pkg"
        fi
    else
        printf "  ✖ Failed to install %s\n" "$pkg"
        echo "    └─ An error occurred. Full log:" >&2
        sed 's/^/       /' "$log_file" >&2
        rm "$log_file"
        exit 1
    fi

    rm "$log_file"
}

# Function to install multiple packages
install_all_packages() {
    local install_cmd_str=$1
    shift
    local packages=($@)
    local install_cmd=($install_cmd_str) # split string into array

    for pkg in "${packages[@]}"; do
        install_package "$pkg" "${install_cmd[@]}"
    done
}

# Function to run a command with a spinner (for bulk commands)
run_with_spinner() {
    local message="$1"
    shift # Remove the message from the arguments
    local command_to_run=($@)

    local log_file
    log_file=$(mktemp) # Create a temporary file for logs

    local spin='|/-\'
    local i=0

    # Run the command in the background, redirecting all output to the log file
    "${command_to_run[@]}" >"$log_file" 2>&1 & 
    local pid=$!

    printf " %s" "$message"

    while kill -0 $pid 2>/dev/null;
do
        i=$(( (i+1) % 4 ))
        printf "\r%c %s" "${spin:$i:1}" "$message"
        sleep 0.1
    done

    wait $pid
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        printf "\r✔ %s\n" "$message"
    else
        printf "\r✖ %s\n" "$message"
        echo "    └─ An error occurred. Full log:" >&2
        # Indent the log output for readability
        sed 's/^/       /' "$log_file" >&2
        exit $exit_code
    fi

    rm "$log_file"
}


# --- Main Script ---
msg "Starting setup..."

# 1. Check for Homebrew
if ! command_exists brew;
  then
  echo "Error: Homebrew is not installed. Please install it from https://brew.sh/" >&2
  exit 1
fi
msg "Homebrew found, proceeding with installation..."

# 2. Install Brew Packages
msg "Installing Homebrew packages"
PACKAGES=(
  lsd lazygit bob fzf mise starship stow zoxide bat bat-extras
  git-delta ripgrep tlrc vivid fastfetch fd git-filter-repo htop jq
)
install_all_packages "brew install" "${PACKAGES[@]}"

# 3. Install Brew Casks
msg "Installing Homebrew casks"
CASKS=(
  betterdisplay font-fantasque-sans-mono-nerd-font
  font-caskaydia-cove-nerd-font font-comic-shanns-mono-nerd-font
  ghostty helium-browser webtorrent krita iina 
  font-caskaydia-cove-nerd-font font-comic-shanns-mono-nerd-font utm zed
)
install_all_packages "brew install --cask" "${CASKS[@]}"

# 4. Stow Dotfiles
msg "Stowing dotfiles"
run_with_spinner "Stowing dotfiles" \
  stow ghostty git lazygit lsd mvim nvim starship zsh

msg "Setup complete! ✨"
