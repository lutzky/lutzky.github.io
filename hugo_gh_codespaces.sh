#!/bin/bash

HUGO_PORT=1313

exec hugo serve \
  --baseUrl="https://${CODESPACE_NAME:?}-${HUGO_PORT:?}.preview.app.github.dev/" \
  --appendPort=false \
  --liveReloadPort 443 \
  "$@"