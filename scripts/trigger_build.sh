#!/usr/bin/env bash
set -euo pipefail
JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
JOB_NAME="${JOB_NAME:-jenkins-rest-api}"
USER_NAME="${USER_NAME:?Set USER_NAME}"
API_TOKEN="${API_TOKEN:?Set API_TOKEN}"
MESSAGE="${MESSAGE:-REST API test}"
ENVIRONMENT="${ENVIRONMENT:-test}"
DEBUG="${DEBUG:-false}"

AUTH=$(printf '%s:%s' "$USER_NAME" "$API_TOKEN" | base64 -w 0)
CRUMB_JSON=$(curl -fsS -H "Authorization: Basic $AUTH" "$JENKINS_URL/crumbIssuer/api/json")
CRUMB_FIELD=$(printf '%s' "$CRUMB_JSON" | sed -n 's/.*"crumbRequestField":"\([^"]*\)".*//p')
CRUMB=$(printf '%s' "$CRUMB_JSON" | sed -n 's/.*"crumb":"\([^"]*\)".*//p')

curl -i -fsS -X POST   -H "Authorization: Basic $AUTH"   -H "$CRUMB_FIELD: $CRUMB"   --data-urlencode "MESSAGE=$MESSAGE"   --data-urlencode "ENVIRONMENT=$ENVIRONMENT"   --data-urlencode "DEBUG=$DEBUG"   "$JENKINS_URL/job/$JOB_NAME/buildWithParameters"

echo
echo "REST API request accepted by Jenkins."
