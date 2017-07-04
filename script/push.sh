#!/bin/sh
set -e
set -u

mkdir -p ~/.gem/ || :
cp -f templates/credentials ~/.gem/
chmod 0600 ~/.gem/credentials
sed -i "s/API_KEY/${API_KEY}/" ~/.gem/credentials

output="$(gem search --remote -a puppet-autostager)"
if echo ${output} | grep ${VERSION}; then
  # Be informative, but don't fail.
  # This enables to merge changes to non-gem files, such as README.
  echo "puppet-autostager ${VERSION} has already been published."
else
  gem push puppet-autostager-${VERSION}.gem || {
    echo ERR: failed to push gem
    exit 1
  } >&2
fi
