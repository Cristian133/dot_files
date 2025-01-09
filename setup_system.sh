#!/usr/bin/env bash

# Function to prompt the user and execute a script
execute_script() {
    local question=$1
    local script_path=$2

    # Ask the user
    read -p "$question (yes/no): " response

    # Normalize the response
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

    # Execute the script if the response is "yes"
    if [[ "$response" == "yes" || "$response" == "y" ]]; then
        if [[ -f "$script_path" ]]; then
            echo "Executing $script_path..."
            bash "$script_path"
        else
            echo "The script $script_path does not exist. Skipping..."
        fi
    else
        echo "Skipping $script_path."
    fi
}

# Ordered list of questions
questions=(
    "First of all we need to set environment variables"
    "Do you want to update the system and install dependencies?"
    "Do you want to compile and install vim?"
    "Do you want to compile and install nvim?"
    "Do you want to compile and install git?"
    "Do you want to install dotfiles?"
    "Do you want to install nerdFonts?"
    "Do you want to install zsh?"
    "Do you want to install tmux and plugins?"
    "Do you want to install Node Version Manager and Node.js?"
)

# List of questions and scripts
declare -A tasks=(
    ["First of all we need to set environment variables"]="env/exports.sh"
    ["Do you want to update the system and install dependencies?"]="sh/install_deps.sh"
    ["Do you want to compile and install vim?"]="sh/install_vim.sh"
    ["Do you want to compile and install nvim?"]="sh/install_neovim.sh"
    ["Do you want to compile and install git?"]="sh/install_git.sh"
    ["Do you want to install dotfiles?"]="sh/install_dotfiles.sh"
    ["Do you want to install nerdFonts?"]="sh/install_fonts.sh"
    ["Do you want to install zsh?"]="sh/install_zsh.sh"
    ["Do you want to install tmux and plugins?"]="sh/install_tmux.sh"
    ["Do you want to install Node Version Manager and Node.js?"]="sh/install_node.sh"
)

# Iterate over the questions in order
for question in "${questions[@]}"; do
    execute_script "$question" "${tasks[$question]}"
done

echo "Process complete!"
