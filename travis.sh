#!/bin/bash

set -euo pipefail

function installTravisTools {
  curl -sSL https://raw.githubusercontent.com/sonarsource/travis-utils/v2.1/install.sh | bash
}

function java_run_its {

  if [ "$1" == "IT-DEV" ]; then
    VERSION="DEV"

    travis_build_green "SonarSource/sonarqube" "master"
  else
    VERSION="5.1.1"

    echo "Downloading latest SonarQube release [$1]..."
    mkdir -p ~/.m2/repository/org/codehaus/sonar/sonar-application/$VERSION
    curl -sSL http://downloads.sonarsource.com/sonarqube/sonarqube-$VERSION.zip -o ~/.m2/repository/org/codehaus/sonar/sonar-application/$VERSION/sonar-application-$VERSION.zip
  fi

  cd its/plugin
  mvn -Dmaven.test.redirectTestOutputToFile=false -Dsonar.runtimeVersion="$VERSION" test -Dtest=com.sonar.it.java.suite.$1

  unset VERSION
}

if [ "$TESTS" == "CI" ]; then
  mvn verify -B -e -V
else
  mvn install -DskipTests=true

  installTravisTools
  java_run_its "${TESTS}" ${IT_TEST_CLASS}
fi
