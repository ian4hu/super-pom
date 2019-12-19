#!/usr/bin/env bash

# Export key
# gpg --quiet --batch --yes --export-secret-key --armor --output key.gpg ${GPG_KEY}

# Encrypt key
# gpg --quiet --batch --yes --passphrase="${GPG_PASSPHRASE}" --cipher-algo AES256 --output encrypt-key.gpg --symmetric key.gpg

# Decrypt the file
#mkdir $HOME/secrets
# --batch to prevent interactive command --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="${GPG_PASSPHRASE}" encrypt-key.gpg  |\
   gpg --quiet --batch --yes --passphrase="${GPG_PASSPHRASE}"  --import
