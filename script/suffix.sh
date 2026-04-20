#!/usr/bin/env bash

# 批量替换当前目录下文件后缀（不处理子目录）

show_help() {
    cat << EOF
用法：
  bash suffix.sh <原后缀> <新后缀>

示例：
  bash suffix.sh sh txt
  表示将当前目录下所有 .sh 文件改名为 .txt

说明：
  1. 只处理当前目录下的普通文件，不处理子文件夹中的文件
  2. 后缀可以带点，也可以不带点，例如：
     bash suffix.sh .sh .txt
     bash suffix.sh sh txt
  3. 若目标文件名已存在，则跳过，避免覆盖
EOF
}

# 没有参数或参数不足时显示帮助
if [ $# -ne 2 ]; then
    show_help
    exit 1
fi

old_ext="$1"
new_ext="$2"

# 去掉可能输入的前导点
old_ext="${old_ext#.}"
new_ext="${new_ext#.}"

# 原后缀为空时退出
if [ -z "$old_ext" ] || [ -z "$new_ext" ]; then
    echo "错误：后缀不能为空"
    echo
    show_help
    exit 1
fi

script_name="$(basename "$0")"

shopt -s nullglob

for file in ./*; do
    # 只处理普通文件
    [ -f "$file" ] || continue

    base_name="$(basename "$file")"

    # 排除脚本自身，避免运行时把自己改名
    [ "$base_name" = "$script_name" ] && continue

    # 判断是否为指定后缀
    if [[ "$base_name" == *."$old_ext" ]]; then
        new_name="${base_name%.$old_ext}.$new_ext"

        if [ -e "./$new_name" ]; then
            echo "跳过：$base_name -> $new_name（目标文件已存在）"
            continue
        fi

        mv -- "$file" "./$new_name"
        echo "已重命名：$base_name -> $new_name"
    fi
done
