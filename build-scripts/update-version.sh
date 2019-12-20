#!/usr/bin/env bash

version=$1

./mvnw versions:set versions:set-scm-tag -DnewVersion=${version} -DnewTag=${version}
./mvnw versions:commit
git add pom.xml
git commit -m "Bump version to ${version}"
git tag -f -a -m "Release ${version}" "${version}"