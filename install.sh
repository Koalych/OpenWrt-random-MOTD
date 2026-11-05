#!/bin/sh

REPO="https://raw.githubusercontent.com/Koalych/OpenWrt-random-MOTD/main"
TMP="$(mktemp -d)" || exit 1
trap 'rm -rf "$TMP"' EXIT

echo "Проверка Bash..."
if ! command -v bash >/dev/null 2>&1; then
    apk add bash || {
        echo "Не удалось установить Bash."
        exit 1
    }
fi

echo "Скачивание файлов..."
wget -qO "$TMP/apk-cheatsheet.sh" "$REPO/etc/profile.d/apk-cheatsheet.sh" || exit 1

mkdir -p "$TMP/banners" /root/banners
while IFS=' ' read -r remote local; do
    [ -n "$remote" ] || continue
    wget -qO "$TMP/banners/$local" "$REPO/root/banners/$remote" || {
        echo "Ошибка загрузки баннера: $local"
        exit 1
    }
done <<'EOF'
bananacat bananacat
cat cat
gigachad gigachad
mike mike
pikachu pikachu
shrek shrek
smile smile
soyjack soyjack
thousand%20yard%20stare thousand_yard_stare
ur%20gay ur_gay
EOF

echo "Установка..."
cp "$TMP/apk-cheatsheet.sh" /etc/profile.d/apk-cheatsheet.sh || exit 1
cp "$TMP"/banners/* /root/banners/ || exit 1
chmod 644 /etc/profile.d/apk-cheatsheet.sh /root/banners/* || exit 1

echo "Переключение root на Bash..."
if [ ! -x /bin/bash ]; then
    echo "/bin/bash не найден, root остаётся на текущем shell."
    exit 1
fi
grep -qx /bin/bash /etc/shells 2>/dev/null || echo /bin/bash >> /etc/shells
if ! grep -q '^root:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:/bin/bash$' /etc/passwd; then
    sed -i 's#^\(root:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:\).*#\1/bin/bash#' /etc/passwd
fi

echo "Отключение стандартного баннера..."
sed -i '\|\[ -f /etc/banner \] && cat /etc/banner|d' /etc/profile

echo "Проверка установки..."
fail=0
ok()  { echo "  [ok] $*"; }
bad() { echo "  [!!] $*"; fail=1; }

[ -x /bin/bash ] && ok "Bash установлен" || bad "Bash не найден в /bin/bash"
grep -qx /bin/bash /etc/shells && ok "/bin/bash есть в /etc/shells" || bad "/bin/bash нет в /etc/shells"
grep -q '^root:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:/bin/bash$' /etc/passwd \
    && ok "Login shell root: Bash" || bad "Login shell root не Bash"
[ -s /etc/profile.d/apk-cheatsheet.sh ] \
    && ok "Скрипт баннера на месте" || bad "Нет /etc/profile.d/apk-cheatsheet.sh"
bash /etc/profile.d/apk-cheatsheet.sh >/dev/null 2>&1 \
    && ok "Скрипт баннера выполняется" || bad "Скрипт баннера завершился с ошибкой"
for f in "$TMP"/banners/*; do
    [ -s "/root/banners/${f##*/}" ] && ok "Баннер ${f##*/}" || bad "Баннер ${f##*/} не установлен"
done
grep -qF '[ -f /etc/banner ] && cat /etc/banner' /etc/profile \
    && bad "Стандартный баннер в /etc/profile не отключён" || ok "Стандартный баннер отключён"

if [ "$fail" -ne 0 ]; then
    echo "Установка завершилась с ошибками."
    exit 1
fi

echo "Готово. Переподключитесь по SSH — root будет использовать Bash."
