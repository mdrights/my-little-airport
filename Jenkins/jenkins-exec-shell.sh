#!/bin/bash
#exec-shell-jenkins.sh

#echo ">> Set Vault Secret (DEV)"
#curl -k --location --request POST 'https://vault.xxx.intranet.asia/v1/kv2/data/sgrass/nprd/uat/osdvum/az1/sgrass-dev-az1-devxxxexpert/azure' \
#--header 'X-Vault-Token: ' \
#--header 'Content-Type: application/json' \
#--data '{
#  "data": {
#  }
#}'


#echo ">> Set Vault Secret (SIT)"
#curl -k --location --request POST 'https://vault.xxx.intranet.asia/v1/kv2/data/sgrass/nprd/uat/osdvum/az1/sgrass-dev-az1-xxxexpert/azure' \
#--header 'X-Vault-Token: s.oG6rZV0bNxZIZA2MofFFgtQe' \
#--header 'Content-Type: application/json' \
#--data '{
#  "data": {
#    "service-bus-pri-conn": "Endpoint=sb://sbn-sgrass-dev-az1-kfdy9w.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=JZZygeCEhzzFThuSZaVn+Xw6J+9PmxcBDgx7sLo2i7g=",
#    "service-bus-sec-conn": "Endpoint=sb://sbn-sgrass-dev-az1-kfdy9w.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=Q/RU1oNj45zPIWQGofZ4ZlHUMM8tELYlOcx8odBOoco="
#  }
#}'



chmod +x ./jq-linux64

  echo "==== Login to Vault with user LDAP credential ===="
  export USERNAME=
  export PASSWORD=''
  export APPROLE_NAME=""
  export VAULT_ADDR="https://vault..asia"
  export KV_PATH=""
  export KV_ENDPOINT=""

  #curl -k -sS -X POST -d '{"password": "'"${PASSWORD}"'"}' ${VAULT_ADDR}/v1/auth/xxxASIA/login/${USERNAME} 
  VAULT_TOKEN=$(curl -k -sS -X POST -d '{"password": "'"${PASSWORD}"'"}' ${VAULT_ADDR}/v1/auth/xxxASIA/login/${USERNAME}  | ./jq-linux64 .auth.client_token )
  VAULT_TOKEN=$(echo $VAULT_TOKEN |tr -d '"')

  echo "==== Read AppRole role-id and secret-id with user token ===="
  ROLE_ID=$(curl -sS -k -H "X-Vault-Token: $VAULT_TOKEN" ${VAULT_ADDR}/v1/auth/approle/role/${APPROLE_NAME}/role-id | ./jq-linux64 .data.role_id)
  SECRET_ID=$(curl -sS -k -H "X-Vault-Token: $VAULT_TOKEN" -X PUT -d 'null' ${VAULT_ADDR}/v1/auth/approle/role/${APPROLE_NAME}/secret-id | ./jq-linux64 .data.secret_id)

  ROLE_ID=$(echo $ROLE_ID |tr -d '"')
  SECRET_ID=$(echo $SECRET_ID |tr -d '"')
  
  
  echo "==== Login to vault with approle role-id and secret-id ===="
  VAULT_TOKEN=$(curl -sS -k -X POST -d '{"role_id": "'"$ROLE_ID"'", "secret_id": "'"$SECRET_ID"'"}' ${VAULT_ADDR}/v1/auth/approle/login | ./jq-linux64 .auth.client_token )
  VAULT_TOKEN=$(echo $VAULT_TOKEN |tr -d '"')
  
  echo "==== List KV path ===="
  curl -sS -k -H "X-Vault-Token: $VAULT_TOKEN" https://vault.xxx.intranet.asia/v1/kv2/metadata/${KV_PATH}?list=true | ./jq-linux64 .data.keys
  
  
  echo "==== Fetch the Secrets ===="
  curl -sS -k --header  "X-Vault-Token: ${VAULT_TOKEN}" --location ${VAULT_ADDR}/v1/kv2/data/${KV_PATH}/${KV_ENDPOINT} | ./jq-linux64
