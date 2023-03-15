#!/bin/bash
echo "以下のシェルスクリプトが利用可能です:"
echo "1. ./sample/script1.sh"
echo "2. ./sample/script2.sh"
echo "3. ./sample/script3.sh"
echo "4. ./sample/script4.sh"
echo "5. ./sample/script5.sh"
echo "6. ./sample/script6.sh"
echo "7. ./sample/script7.sh"
echo "8. ./sample/script8.sh"
echo "9. ./sample/script9.sh"
echo "10. ./sample/script10.sh"
echo ""
echo "実行するシェルスクリプトの名前を入力してください:"
read scriptname

if [ -f "$scriptname" ]
then
    chmod +x $scriptname
    ./$scriptname
else
    echo "$scriptname が見つかりませんでした。"
fi