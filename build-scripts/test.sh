#!/usr/bin/env bash
#set -x

function log_count() {
    file=$1
    search=$2
    cat $file | grep -c "$search"
}

function assert() {
    desc=$1
    expect=$2
    actual=$3
    if [[ "x$expect" == "x${actual}" ]]; then
        echo "[PASS] [${desc}]"
        exit 0
    else
        echo "[FAIL] [${desc}] Assert failed: expect: '${expect}' but got: '${actual}'"
        exit 1
    fi
}

function log_section() {
    echo "------------------------------------------------------------------------"
    echo "--- $@ ---"
    echo "------------------------------------------------------------------------"
}

MVN="${PWD}/mvnw -B"

${MVN} install

cd multi-module-demo

hasError=0

log_section "build with -Denforcer.fail=false"
${MVN} compile -Denforcer.fail=false | tee ./mvn-compile-full.txt

log_section "Assert build log ./mvn-compile-full.txt"
(assert "ReactorModuleConvergence failed" 4 "$(log_count ./mvn-compile-full.txt "ReactorModuleConvergence failed")") || hasError=$?
(assert "DependencyConvergence failed" 2 "$(log_count ./mvn-compile-full.txt "Dependency convergence error for")") || hasError=$?
(assert "BanDuplicatePomDependencyVersions failed" 1 "$(log_count ./mvn-compile-full.txt "BanDuplicatePomDependencyVersions failed")") || hasError=$?
(assert "BannedDependencies failed" 2 "$(log_count ./mvn-compile-full.txt "BannedDependencies failed")") || hasError=$?
(assert "BanVulnerableDependencies failed" 1 "$(log_count ./mvn-compile-full.txt "BanVulnerableDependencies failed")") || hasError=$?
(assert "BanDuplicateClasses failed" 1 "$(log_count ./mvn-compile-full.txt "BanDuplicateClasses failed")") || hasError=$?
(assert "Expoect Build Success" 1 "$(log_count ./mvn-compile-full.txt "BUILD SUCCESS")") || hasError=$?

echo ""
log_section "build with fast fail"
${MVN} compile | tee ./mvn-compile.txt

log_section "Assert build log ./mvn-compile.txt"
(assert "ReactorModuleConvergence failed" 1 "$(log_count ./mvn-compile.txt "ReactorModuleConvergence failed")") || hasError=$?
(assert "Expoect Build Fail" 1 "$(log_count ./mvn-compile.txt "BUILD FAILURE")") || hasError=$?

echo ""

result="BUILD SUCCESS"
[[ 0 == $hasError ]] || result="BUILD FAILURE"
log_section "Test result"
echo $result


# clean up
rm -rf ~/.m2/repository/com/gitee/ian4hu
rm -rf ~/.m2/repository/com/github/ian4hu

exit ${hasError}