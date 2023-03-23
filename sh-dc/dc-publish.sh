#!/bin/bash

# Dockerコンテナの一覧を取得し、配列に格納
containers=($(docker ps --format "{{.Names}}"))

# 公開されているポートがあるコンテナのリストを格納する配列を初期化
exposed_containers=()

# 各コンテナのポート情報を取得し、公開されているポートがある場合は配列に追加する
for container in "${containers[@]}"; do
  ports=$(docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} {{end}}' "$container")
  if [[ ! -z "$ports" ]]; then
    exposed_containers+=("$container")
  fi
done

# 公開されているポートがあるコンテナがない場合はエラーメッセージを出力して終了する
if [[ "${#exposed_containers[@]}" -eq 0 ]]; then
  echo "No containers with exposed ports found"
  exit 0
fi

# 公開されているポートがあるコンテナの名前を出力する
echo "Containers with exposed ports:"
for container in "${exposed_containers[@]}"; do
  echo "- $container"
done
