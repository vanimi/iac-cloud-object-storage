#!/usr/bin/env bash

if [ "$PIPELINE_DEBUG" = "1" ]; then
  pwd
  env
  trap env EXIT
  set -x +e

  export IBMCLOUD_TRACE=true
fi

if [ -z "$(get_env release-tag "")" ]; then
  echo "NO NEW VERSION RELEASED - No tag to sign"
else
  cd "${WORKSPACE}/$(load_repo app-repo path)" || exit 1

  # Create the detached signature
  base64 -d <<< "$(get_env signing-key)" > ../private_key.txt
  if [[ -s ../private_key.txt ]]; then
    echo "Base64 Conversion is successful...."
  else
    echo "Base64 Conversion is unsuccessful. Please check the key."
    exit 1
  fi
  gpg2 --import ../private_key.txt

  # Retrieve the gpg signing key id to use
  gpg2 --list-signatures
  KEYS=$(gpg2 -k --with-colons)
  TRIMMEDKEYS=$(echo "$KEYS" | tr -d '\n')
  IFS=':' read -r -a TEMPARRAY <<< "$TRIMMEDKEYS"
  KEY_ID="${TEMPARRAY[11]}"

  # Specify the git account identity - required for tag signing
  git config user.email "$(get_env git-user-email)"
  git config user.name "$(get_env git-user-name)"

  # Format is git config user.signingkey KEY-ID
  git config user.signingkey "$KEY_ID"

  # List tags
  git tag -l -n

  # Retrieve tag message
  message=$(git tag -l --format='%(contents)' "$(get_env release-tag)")

  # replace and force tag message
  git tag "$(get_env release-tag)" "$(get_env release-tag)" -f -s -m "$message"
  git push origin "$(get_env release-tag)" -f
fi
