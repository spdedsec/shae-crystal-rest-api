#!/usr/bin/env bash
set -euo pipefail
echo "Installing shae-crystal-rest-api (Crystal language tool)"
echo "Build: crystal build src/rest_api.cr -o shae-rest-api"
echo "Install: cp shae-rest-api ~/.local/bin/"
echo "Usage: shae-rest-api (listens on :8080)"
