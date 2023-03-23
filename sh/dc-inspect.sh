#!/bin/bash

# Dockerコンテナの一覧を取得し、配列に格納
containers=($(docker ps --format "{{.Names}}"))

# ユーザーにコンテナの名前を選択させる
echo "Choose a container:"
for i in "${!containers[@]}"; do
  echo "$((i+1)). ${containers[i]}"
done

read -p "> " selection

if [[ ! "$selection" =~ ^[0-9]+$ || "$selection" -lt 1 || "$selection" -gt "${#containers[@]}" ]]; then
  echo "Invalid selection"
  exit 1
fi

# 選択されたコンテナの名前を取得し、Dockerコマンドを実行する
container_name="${containers[$((selection-1))]}"

echo "You selected container $container_name"
echo "Choose a Docker command to execute:"
echo "1. docker stop"
echo "2. docker start"
echo "3. docker restart"
echo "4. docker logs"
echo "5. 接続可能なすべてのコンテナに対して簡単な動作確認"

read -p "> " command_selection

case "$command_selection" in
  1) docker stop "$container_name";;
  2) docker start "$container_name";;
  3) docker restart "$container_name";;
  4) docker logs "$container_name";;
  5) ./sh/dc-libs/dc-network.sh "$container_name";;
  *) echo "Invalid selection"; exit 1;;
esac
