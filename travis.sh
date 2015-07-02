#!/bin/bash

set -euo pipefail

function installTravisTools {
  curl -sSL https://raw.githubusercontent.com/sonarsource/travis-utils/master/install.sh | bash
}

if [ "$TESTS" == "CI" ]; then
  mvn verify -B -e -V
else
  mvn install -DskipTests=true

  installTravisTools
  travis_run_its "${TESTS}" -Dtest=com.sonar.it.java.suite.${IT_TEST_CLASS}
fi
