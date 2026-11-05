# OpenWrt Random MOTD

Скрипты для случайного ASCII MOTD при входе в систему OpenWrt по SSH.

## Возможности

- Выводит один случайный баннер из `/root/banners/` при запуске login shell Bash.
- В комплект входят 10 ASCII-баннеров.
- Установщик проверяет наличие Bash и при необходимости устанавливает его через `apk`.
- Переключает login shell пользователя `root` на `/bin/bash`.
- Убирает стандартный вывод `/etc/banner` из `/etc/profile`, чтобы он не дублировался.
- Проверяет установленные файлы, настройки shell и запуск скрипта после установки.

## Установка

Запустите от `root` на устройстве OpenWrt:

```sh
wget -O /tmp/install.sh https://raw.githubusercontent.com/Koalych/OpenWrt-random-MOTD/main/install.sh
sh /tmp/install.sh
```

После завершения переподключитесь по SSH, чтобы применился новый shell.

## Ручная установка

Установщик размещает файлы так:

- `etc/profile.d/apk-cheatsheet.sh` → `/etc/profile.d/apk-cheatsheet.sh`
- `root/banners/*` → `/root/banners/`

Скрипт в `/etc/profile.d/apk-cheatsheet.sh` выбирает случайный файл из `/root/banners/` и печатает его. Требуется Bash.

## Предупреждение

Установщик изменяет `/etc/passwd`, `/etc/shells` и `/etc/profile`, а также устанавливает Bash и файлы в `/root`. Используйте его только на своём устройстве и проверьте изменения перед запуском.

