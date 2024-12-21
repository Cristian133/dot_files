#!/usr/bin/env bash

# Check if the DEV variables are defined
if [ -z "${DEV+x}" ]; then
    echo "Error: The variable DEV is not defined. Please define it before running the script."
    exit 1
fi

# Configuración de variables
currentDir="$(pwd)"
buildDir="${HOME}/${DEV}/git-build"
gitRepo="https://github.com/git/git/archive/refs/heads/maint.zip"
zipFile="$buildDir/git.zip"

# Crear directorio de compilación
mkdir -p "$buildDir" || { echo "Error creating build directory."; exit 1; }

# Descargar el código fuente de Git
wget "$gitRepo" -O "$zipFile" || { echo "Error downloading Git source."; exit 1; }

# Extraer el archivo ZIP
cd "$buildDir" || exit 1
unzip -q "$zipFile" || { echo "Error extracting ZIP file."; exit 1; }

# Cambiar al directorio del código fuente
cd git-* || { echo "Error navigating to Git source directory."; exit 1; }

# Obtener la versión actual instalada y la versión descargada
currentGitVersion=$(git --version | sed -e 's/git version //')
downloadGitVersion=$(cat GIT-VERSION-GEN | grep -o "$currentGitVersion")

# Compilar e instalar si es necesario
if [ -z "$downloadGitVersion" ]; then
    make prefix=/usr/local all || { echo "Error during make."; exit 1; }
    if sudo make prefix=/usr/local install; then
        echo "Git successfully compiled and installed."
    else
        echo "Error during make install." >&2
        exit 1
    fi
else
    echo "Git is already up to date: $downloadGitVersion"
fi

# Volver al directorio inicial
cd "$currentDir" || exit 1

# limpiar
sudo rm -rf ${HOME}/${DEV}/git-build;
