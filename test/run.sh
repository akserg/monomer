#!/bin/bash

# Static type analysis
results=$(dartanalyzer test/monomer_tests.dart 2>&1)
echo "$results"
if [[ "$results" == *"warnings found"* || "$results" == *"error"* ]]
then
  exit 1
fi

cs_path=$(ls -d drt-* >/dev/null 2>&1)
if [[ $? -ne 0 ]]; then
  echo Downloading content_shell ...
  $DART_HOME/../chromium/download_contentshell.sh > /dev/null 2>&1
  unzip content_shell-linux-x64-release.zip 
  cs_path=$(ls -d drt-*) 
fi

$cs_path/content_shell --dump-render-tree test/monomer_tests.html > test.log 2>&1

if grep -q "FAIL" test.log; then
  cat test.log
  echo FAILED
  exit 1
else
  echo SUCCESS
fi

