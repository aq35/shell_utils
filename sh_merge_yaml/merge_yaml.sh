# あらかじめ実行権限を与えてください。
# chmod +x merge_yaml.sh
# ./merge_yaml.sh merged.yaml ./sample/file1.yaml ./sample/file2.yaml ./sample/file3.yaml
#!/bin/bash

# 結合先のファイル名を指定
MERGED_FILE="$1"

# 結合する YAML ファイルのパスをコマンド引数から取得
YAML_FILES=("${@:2}")


# 結合先のファイルを作成
touch "${MERGED_FILE}"

# 各 YAML ファイルの内容を結合
for file in "${YAML_FILES[@]}"
do
  if [ -f "$file" ]; then
    cat "$file" >> "${MERGED_FILE}"
  fi
done

echo "YAML ファイルを結合しました。"