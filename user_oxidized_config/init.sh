#!/bin/bash

set -e

DRIVER="$1"
ROLE_NAME="$2"
DESCRIPTION="$3"

if [[ -z "$DRIVER" || -z "$ROLE_NAME" || -z "$DESCRIPTION" ]]; then
  echo "Использование: $0 <driver> <role-name> <description>"
  echo "Пример: $0 proxmox deploy_docker \"Роль для установки Docker\""
  exit 1
fi

echo "[INFO] Инициализация шаблона роли:"
echo "       Драйвер:      $DRIVER"
echo "       Имя роли:     $ROLE_NAME"
echo "       Описание:     $DESCRIPTION"

git submodule update --init --recursive

cp -r molecule-template/molecule molecule/
cp molecule-template/.ansible-lint .
cp molecule-template/.env .
cp molecule-template/.yamllint .
rm -rf molecule-template

DRIVER_DIR="molecule/default/molecule-${DRIVER}-driver"
if [[ ! -d "$DRIVER_DIR" ]]; then
  echo "Ошибка: драйвер '$DRIVER' не найден по пути: $DRIVER_DIR"
  exit 1
fi

cp "$DRIVER_DIR/create.yml" molecule/default/create.yml
cp "$DRIVER_DIR/destroy.yml" molecule/default/destroy.yml
cp "$DRIVER_DIR/molecule.yml" molecule/default/molecule.yml
find molecule/default/ -type d -name 'molecule-*-driver' -exec rm -rf {} +

META_FILE="meta/main.yml"

if [[ -f "$META_FILE" ]]; then
  echo "[INFO] Обновление meta/main.yml..."
  sed -i "s|{{ *ROLE_NAME *}}|$ROLE_NAME|g" "$META_FILE"
  sed -i "s|{{ *DESCRIPTION *}}|$DESCRIPTION|g" "$META_FILE"
else
  echo "⚠️  Внимание: meta/main.yml не найден"
fi

rm -rf .git

echo "[SUCCESS] Инициализация завершена."
