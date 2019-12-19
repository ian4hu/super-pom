#!/usr/bin/env bash

# update version
# ./mvnw versions:set -DnewVersion=${NEW_VERSION}

./mvnw -B clean package deploy \
  -s ./ossrh-settings.xml \
  -P release-to-ossrh \
  -Dgpg.passphrase=${GPG_PASSPHRASE} \
  -Dossrh.username=${OSSRH_USERNAME} \
  -Dossrh.password=${OSSRH_PASSWORD} \


