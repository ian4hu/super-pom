#!/usr/bin/env bash
SCRIPT_HOME=./build-scripts
# Export key
# gpg --quiet --batch --yes --export-secret-key --armor --output key.gpg ${GPG_KEY}

# Encrypt key
# gpg --quiet --batch --yes --passphrase="${GPG_PASSPHRASE}" --cipher-algo AES256 --output encrypt-key.gpg --symmetric key.gpg

# Decrypt the file
#mkdir $HOME/secrets
# --batch to prevent interactive command --yes to assume "yes" for questions
gpg --list-keys
gpg --quiet --batch --yes --decrypt --passphrase="${GPG_PASSPHRASE}" ${SCRIPT_HOME}/secrets/encrypt-key.gpg |\
   gpg --quiet --batch --yes --passphrase="${GPG_PASSPHRASE}"  --import
