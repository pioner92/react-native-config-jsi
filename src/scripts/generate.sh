#!/bin/bash

ENV_FILE="${SRCROOT}/../.env"

PROJECT_NAME=$(basename $(find "${SRCROOT}" -maxdepth 1 -name "*.xcodeproj") .xcodeproj)


# INFO_PLIST="${SRCROOT}/intch_application/Info.plist" # Замените на путь к вашему Info.plist
INFO_PLIST="${SRCROOT}/${PROJECT_NAME}/Info.plist"

# Проверяем, что Info.plist существует
if [ ! -f "$INFO_PLIST" ]; then
  echo "❌ Info.plist not found at $INFO_PLIST"
  exit 1
fi

# Парсим .env и записываем все пары ключ=значение в Info.plist
while IFS= read -r line || [ -n "$line" ]; do
  # Пропускаем комментарии и пустые строки
  if [[ "$line" =~ ^#.* || -z "$line" ]]; then
    continue
  fi

  # Обрабатываем строку вида KEY=VALUE (учитываем пробелы вокруг '=')
  if [[ "$line" =~ ^[[:space:]]*([^=[:space:]]+)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
    key="${BASH_REMATCH[1]}"
    value="${BASH_REMATCH[2]}"

    # Убираем возможные кавычки вокруг значения
    value="${value%\"}"
    value="${value#\"}"

    # Удаляем старую запись, если есть
    /usr/libexec/PlistBuddy -c "Delete :$key" "$INFO_PLIST" 2>/dev/null

    # Добавляем новую запись
    /usr/libexec/PlistBuddy -c "Add :$key string $value" "$INFO_PLIST"
    echo "✅ $key=\"$value\" written to Info.plist"
  fi
done < "$ENV_FILE"