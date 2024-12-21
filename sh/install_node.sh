#!/usr/bin/env bash

# Check if the DEV variables are defined
variables=("NODE_DEFAULT_VERSION" "NVM_VERSION")

for var in "${variables[@]}"; do
    if [ -z "${!var+x}" ]; then
        echo "Error: The variable $var is not defined. Please define it before running the script."
        exit 1
    fi
done

# download and run the script
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install ${NODE_DEFAULT_VERSION}

npm i -g n yarn npm pnpm @microsoft/rush @angular/cli;
