# KC IDP CONFIG
export IDP_DISCOVERY_DOCUMENT="https://identity.harmoneylabs.com/realms/internal/.well-known/openid-configuration"
export TEST_IDP_APIGEE_CLIENT_ID="apigee"
export TEST_IDP_APIGEE_CLIENT_SECRET="<get it from identity KC -> Internal -> apigee -> credentials -> client secret>"
export IS_PKCE_ENABLED=true

export AUTH_REQ_SCOPE="openid%20email%20profile"
export AUTH_REQ_REDIRECT_URI="https%3A%2F%2Fharmonize.harmoneylabs.com%2F"

# GCP APIGEE
export APIGEE_X_ORG="harmoney-core-platform-dev"
export APIGEE_X_ENV="eval"
export APIGEE_X_HOSTNAME="api.harmoneylabs.com"

./pipeline.sh --googleapi