#!/bin/bash
echo "==== Secrets manager ===="
SECRETS_PATH="lib/secrets.dart"

case $1 in
  encrypt)
    echo " Encrypting secrets ...";
    gpg -c $SECRETS_PATH;;
  decrypt)
    echo " Decrypting secrets ...";
    gpg -d "$SECRETS_PATH.gpg" > $SECRETS_PATH;;
  ?)
    echo " Unknown command";;
esac