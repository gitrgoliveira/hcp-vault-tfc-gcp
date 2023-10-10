#!/bin/bash
echo "******************************************************************"
echo "* Script to setup challenge                                      *"
echo "******************************************************************"
echo
echo
echo "Please enter your Terraform Organization."
read TFE_ORGANIZATION
echo
echo "Please enter your Terraform  access token."
read -s TFE_TOKEN
echo
echo "Please enter your HCP Vault address."
read VAULT_ADDR
echo
echo "Please enter your HCP Vault admin token."
read -s VAULT_TOKEN
echo
echo "Terraform Organization : $TFE_ORGANIZATION"
# echo "Terraform Token : $TFE_TOKEN"
echo "HCP Vault hostname : $VAULT_ADDR"
# echo "HCP Vault token : $VAULT_TOKEN"
echo
read -p "Do these look right to you? Y/n " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Please try again."
  exit 1
fi
echo

cat >> credentials.env <<EOM
export TFE_ORGANIZATION=$TFE_ORGANIZATION
export TFE_TOKEN=$TFE_TOKEN
export VAULT_ADDR=$VAULT_ADDR
export VAULT_TOKEN=$VAULT_TOKEN
EOM

source credentials.env

[ -z "${GOOGLE_CREDENTIALS}" ] || echo "${GOOGLE_CREDENTIALS}" > credentials.json

cat >> terraform.tfvars <<EOM
terraform_organization="$TFE_ORGANIZATION"
# vault_address="$VAULT_ADDR"
EOM
exit 0
