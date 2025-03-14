#!/bin/bash

# 对主工程执行 flutter pub get
echo "Running flutter pub get in the main project..."
flutter pub get

# 对所有本地库执行 flutter pub get
for dir in packages/*; do
  if [[ -d "$dir" && -f "$dir/pubspec.yaml" ]]; then
    echo "Running flutter pub get in $dir..."
    (cd "$dir" && flutter pub get)
  fi
done

echo "Done!"

# cd 到scripts文件中 执行命令语句： bash pub_get_all.sh  即可对所有本地库执行flutter pub get命令

# 更加专业快捷的方法是使用 melos 工具