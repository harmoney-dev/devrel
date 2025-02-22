#!/bin/sh

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

TOKEN="$(gcloud config config-helper --force-auth-refresh --format json | jq -r '.credential.access_token')"

# Deploy the proxy
mvn clean install -ntp -B -Pgoogleapi -Dorg="$APIGEE_X_ORG" -Denv="$APIGEE_X_ENV" \
  -Dtoken="$TOKEN"

# Run the Integration test
curl -X POST \
    "https://apigee.googleapis.com/v1/organizations/${APIGEE_X_ORG}/environments/$APIGEE_X_ENV/keyvaluemaps" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"name": "kvmtestmap", "encrypted": true}'

curl -X POST \
    "https://apigee.googleapis.com/v1/organizations/${APIGEE_X_ORG}/keyvaluemaps" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"name": "kvmtestmap", "encrypted": true}'


# Environment-Scoped Test
APIGEE_TOKEN="$TOKEN" TEST_BASE_URI="$APIGEE_X_HOSTNAME/kvm-admin/v1/organizations/$APIGEE_X_ORG/environments/$APIGEE_X_ENV" npm run test

# Organization-Scoped Test
APIGEE_TOKEN="$TOKEN" TEST_BASE_URI="$APIGEE_X_HOSTNAME/kvm-admin/v1/organizations/$APIGEE_X_ORG" npm run test

curl -X DELETE \
    "https://apigee.googleapis.com/v1/organizations/${APIGEE_X_ORG}/environments/$APIGEE_X_ENV/keyvaluemaps/kvmtestmap" \
    -H "Authorization: Bearer $TOKEN"

curl -X DELETE \
    "https://apigee.googleapis.com/v1/organizations/${APIGEE_X_ORG}/keyvaluemaps/kvmtestmap" \
    -H "Authorization: Bearer $TOKEN"

