#!/usr/bin/env bash

if [ "$PIPELINE_DEBUG" = "1" ]; then
  pwd
  env
  trap env EXIT
  set -x +e

  export IBMCLOUD_TRACE=true
fi

# install pre-commit if needed
if pre-commit --version > /dev/null 2>&1; then
  echo "Using already installed pre-commit"
else
  pre_commit_version="$(get_env pre-commit-version "v2.17.0")"
  echo "Installing pre-commit $pre_commit_version"
  pip3 install "pre-commit==${pre_commit_version}"
fi
pre-commit --version

run-pre-commit() {
  # run pre-commit if a .pre-commit file is found
  local pre_commit_config_file
  pre_commit_config_file="$(get_env pre-commit-config-file ".pre-commit-config.yaml")"
  if [ -f "${pre_commit_config_file}" ]; then
    pre-commit install --config "${pre_commit_config_file}"

    # configure SKIP environment if needed
    export SKIP
    SKIP="$(get_env pre-commit-skip-hooks "")"

    # execute pre-commit
    pre-commit run --config "${pre_commit_config_file}" --all-files
    exit_code=$?

    return $exit_code
  fi
}
