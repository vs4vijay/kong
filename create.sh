#!/usr/bin/env bash

KONG_ADMIN_HOST="http://localhost:8001"
KONG_PROXY_HOST="http://localhost:8000"

function create_service() {
  local name="$1"
  local url="$2"
  curl -i -X POST \
    --url "${KONG_ADMIN_HOST}/services" \
    --data "name=${name}" \
    --data "url=${url}"
}

function create_route() {
  local service_name="$1"
  local route_name="$2"
  local path="$3"
  curl -i -X POST \
    --url "${KONG_ADMIN_HOST}/services/${service_name}/routes" \
    --data "name=${route_name}" \
    --data "paths[]=${path}"
}

function add_rate_limiting() {
  curl -i -X POST \
    --url "${KONG_ADMIN_HOST}/plugins" \
    --data "name=rate-limiting" \
    --data "config.minute=5" \
    --data "config.policy=local"
}

function add_authentication() {
  local route_name="$1"
  curl -i -X POST \
    --url "${KONG_ADMIN_HOST}/routes/${route_name}/plugins" \
    --data "name=key-auth"
}

function create_consumer() {
  local username="$1"
  local key="$2"
  curl -i -X POST \
    --url "${KONG_ADMIN_HOST}/consumers" \
    --data "username=${username}" \
    --data "custom_id=${username}"

  curl -i -X POST \
    --url "${KONG_ADMIN_HOST}/consumers/${username}/key-auth" \
    --data "key=${key}"
}

function main() {
  echo "[+] Start"

  local service_name="my-service"
  local route_name="my-route"

  echo "[+] Creating Service: ${service_name}"
  create_service "${service_name}" "https://service.theapispace.com/"

  echo "[+] Creating Route: ${route_name}"
  create_route "${service_name}" "${route_name}" "/test"

  echo "[+] Applying Rate Limit"
  add_rate_limiting

  echo "[+] Enabling Authentication"
  add_authentication "${route_name}"

  echo "[+] Creating Consumer: viz"
  create_consumer "viz" "vizkey"

  echo "[+] Finish"
}

main