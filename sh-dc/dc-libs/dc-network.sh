#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 確認のために接続可能なすべてのコンテナに対して簡単な動作確認を実行することができます。
# コンテナ名を引数として受け取る
CONTAINER_NAME=$1

# コンテナ名が指定されていない場合はエラーを表示して終了
if [ -z "$CONTAINER_NAME" ]; then
  echo -e "${YELLOW}コンテナ名は存在しません。${NC}"
  echo "使用法: $0 CONTAINER_NAME"
  exit 1
fi

# コンテナのIDを取得する
CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")

# コンテナが見つからない場合はエラーを表示して終了
if [ -z "$CONTAINER_ID" ]; then
  echo -e "${YELLOW}指定されたコンテナIDは存在しません。${NC}"
  exit 1
fi

# 接続可能なコンテナ名のリストを取得する
declare -a CONTAINERS
for NETWORK in $(docker inspect -f '{{range $key, $value := .NetworkSettings.Networks}}{{$key}} {{end}}' $CONTAINER_ID); do
  for CONTAINER in $(docker network inspect $NETWORK | jq -r '.[].Containers | keys | .[]'); do
    if [ "$CONTAINER" != "$CONTAINER_ID" ]; then
      NAME=$(docker ps --filter id=$CONTAINER --format "{{.Names}}")
      CONTAINERS+=("$NAME")
    fi
  done
done

# 重複を排除して表示する
CONTAINERS=$(echo "${CONTAINERS[@]}" | tr ' ' '\n' | sort | uniq)

echo "接続可能なコンテナに実際に接続して動作確認を行います..."
# 接続可能なコンテナに対して簡単な動作確認を実行する
for NAME in $CONTAINERS; do
    # コンテナに接続してコマンドを実行することで、接続の動作確認を行う
    RESULT=$(docker exec $NAME echo "接続に成功しました。" 2>&1)
    if [ $? -eq 0 ]; then
     echo -e "${GREEN}$NAME 接続テストに成功しました。${NC}"
    else
    echo -e "${RED}$NAME 接続テストに失敗しました。${NC}"
    echo "$NAME 失敗理由: $RESULT"
    fi
done

# このスクリプトでは、jq コマンドを使用してネットワークに接続されているコンテナの情報をパースしています。
# jq コマンドがインストールされていない場合は、以下のコマンドを使用してインストールできます。

# jqがあるかどうか調べたい
# jq --version

# インストール

# Ubuntu、Debian、Mintの場合：
# sudo apt-get update && sudo apt-get install jq

# macOSの場合（Homebrewを使用している場合）：
# brew install jq
