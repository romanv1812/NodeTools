#!/bin/bash

# URL файла genesis.json
GENESIS_URL="$1"

# Загрузка содержимого файла genesis.json
GENESIS_CONTENT=$(curl -s "$GENESIS_URL")

# Извлечение значения CHAIN
CHAIN=$(echo "$GENESIS_CONTENT" | jq -r '.chain_id')

# Извлечение всех уникальных значений TOKEN
TOKENS=$(echo "$GENESIS_CONTENT" | jq -r '.. | select(.denom?) | .denom' | sort | uniq)

echo "CHAIN: $CHAIN"
echo "TOKENS: $TOKENS"
