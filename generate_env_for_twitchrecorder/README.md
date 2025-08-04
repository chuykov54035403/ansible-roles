Ansible Role Template
=====================

Этот репозиторий представляет собой шаблон для создания Ansible-ролей с поддержкой Molecule и возможностью выбора драйвера при инициализации.

---

Состав шаблона
--------------

- Базовая структура Ansible-роли: `tasks/`, `handlers/`, `defaults/`, `vars/`, `meta/`
- Поддержка Molecule через шаблонные конфигурации:
  - `molecule/default/molecule.yml`
  - `create.yml`, `destroy.yml`
- Конфигурации качества кода:
  - `.ansible-lint`
  - `.yamllint`
  - `.env` для тестов
- Подмодули для драйверов Molecule (например, `proxmox`)

---

Использование
-------------

1. Клонируйте шаблон вместе с подмодулями:

   ```bash
   git clone https://your.git/role_template.git
   cd role_template
   ```

2. Запустите скрипт `init.sh`, передав:

   - имя драйвера (`proxmox`, `docker`, и т.д.)
   - имя создаваемой роли
   - краткое описание роли

   Пример:

   ```bash
   ./init.sh proxmox deploy_docker "Роль для установки и настройки Docker"
   ```

3. Скрипт выполнит:

   - инициализацию подмодулей;
   - копирование нужных файлов из `molecule-template`;
   - подстановку имени и описания в `meta/main.yml`;
   - выбор нужного драйвера Molecule и удаление остальных.

---

Драйверы Molecule
-----------------

Поддержка драйверов реализована через каталоги:

```
molecule-template/molecule/default/molecule-<driver>-driver/
```

Каждый содержит свои `create.yml`, `destroy.yml` и `molecule.yml`. При вызове `init.sh` они копируются в `molecule/default/`.

---