#!/usr/bin/env bash
set -euo pipefail

ENV_URL="https://generaldemosl.crm.dynamics.com"
PROFILE_NAME="HATCHRFIDemo"

echo "Creating/refreshing PAC auth profile: ${PROFILE_NAME}"
pac auth create --name "${PROFILE_NAME}" --environment "${ENV_URL}"

echo "Selecting profile: ${PROFILE_NAME}"
pac auth select --name "${PROFILE_NAME}"

echo "Connection established."
pac org who
