#!/usr/bin/env bash

# sync NVT
rm /usr/local/var/run/feed-update.lock /var/run/ospd/feed-update.lock
if [ "$(ls -A /usr/local/var/lib/openvas/plugins | wc -l)" != "0" ]; then
  echo "Sync NVT with 'rsync'"
  # Workaround - https://github.com/greenbone/openvas/issues/508
  # rsync with -z to improvement download speed
  /usr/bin/rsync -ltvrPz --delete --exclude private/ ${COMMUNITY_NVT_RSYNC_FEED} "/usr/local/var/lib/openvas/plugins"
  greenbone-nvt-sync --rsync
else
  echo "Sync NVT with 'wget'"
  greenbone-nvt-sync --wget
  # Workaround - https://github.com/greenbone/openvas/issues/508
  /usr/bin/rsync -ltvrPz --delete --exclude private/ ${COMMUNITY_NVT_RSYNC_FEED} "/usr/local/var/lib/openvas/plugins"
fi
