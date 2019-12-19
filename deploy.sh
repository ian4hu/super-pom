#!/usr/bin/env bash

./mvnw deploy \
  -s ./ossrh-settings.xml \
  -P release-to-ossrh \
  -Dgpg.passphrase=${GPG_PASSPHRASE} \
  -Dossrh.username=${OSSRH_USERNAME} \
  -Dossrh.password=${OSSRH_PASSWORD} \


