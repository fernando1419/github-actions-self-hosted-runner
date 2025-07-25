#!/bin/bash

# === SETTINGS ===
REPO_URL="https://github.com/fernando1419/github-actions-self-hosted-runner"
REG_TOKEN="AAGFN6GYTGIKFSUXMNZ2PA3IQQO6W"
RUNNER_NAME="mi-first-self-hosted-runner-with-vm"
RUNNER_LABELS="self-hosted,linux,vm,vagrant,ubuntu,focal64"
RUNNER_DIRECTORY="$HOME/actions-runner"
USERNAME="vagrant"
RUNNER_VERSION="2.326.0"
RUNNER_TAR="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# === INSTALAR DEPENDENCIAS ===
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git docker.io
sudo usermod -aG docker $USERNAME

# === BORRAR DIRECTORIO SI EXISTE ===
if [ -d "$RUNNER_DIRECTORY" ]; then
  echo "🧹 Deleting $RUNNER_DIRECTORY directory to prevent configuration errors...."
  rm -rf "$RUNNER_DIRECTORY"
fi

# === CREAR Y ENTRAR AL DIRECTORIO ===
mkdir -p "$RUNNER_DIRECTORY"
cd "$RUNNER_DIRECTORY" || exit 1
echo "📂 Current directory using pwd command: $(pwd)"

# === DOWNLOAD RUNNER (IF NOT EXITS) ===
if [ ! -f "$HOME/$RUNNER_TAR" ]; then
  # wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
  echo "✅ Runner tar file not exists, downloading it..."
  curl -o $RUNNER_TAR -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TAR}

else
  echo "✅ Runner tar file already downloaded, skipping download..."
  mv "$HOME/$RUNNER_TAR" .
fi

# === EXTRACT RUNNER TAR FILE ===
tar xzf "$RUNNER_TAR"

# === CONFIGURE RUNNER ===
./config.sh --url "$REPO_URL" \
            --token "$REG_TOKEN" \
            --name "$RUNNER_NAME" \
            --labels "$RUNNER_LABELS" \
            --work _work \
            --replace \
            --unattended

# === INSTALAR Y EJECUTAR SERVICIO (sin sudo) ===
echo "🔧 Instalando como servicio..."
cd "$RUNNER_DIRECTORY"
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status

echo "✅ Runner running and active as a service..."
