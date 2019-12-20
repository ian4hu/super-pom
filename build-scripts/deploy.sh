#!/usr/bin/env bash
SCRIPT_HOME=./build-scripts

# update version
# ./mvnw versions:set -DnewVersion=${NEW_VERSION}

./mvnw -B clean package deploy \
  -s ${SCRIPT_HOME}/ossrh-settings.xml \
  -P release-to-ossrh \
  -Dgpg.passphrase=${GPG_PASSPHRASE} \
  -Dossrh.username=${OSSRH_USERNAME} \
  -Dossrh.password=${OSSRH_PASSWORD} \


