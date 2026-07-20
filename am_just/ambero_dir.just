# Generuje lub aktualizuje plik konfiguracyjny ze ścieżkami w config/ambero_paths.toml
[no-cd]
create-dir:
    @echo "🚀 Inicjalizacja skryptu konfiguracyjnego..."
    @mkdir -p "{{AMBERO_DIR}}/config"
    @mkdir -p "{{AMBERO_DIR}}/logs"
    @bash -c ' \
    TARGET="{{AMBERO_DIR}}/config/ambero_paths.toml"; \
    TMP_FILE=$(mktemp); \
    \
    echo "[system]" > "$TMP_FILE"; \
    echo "core = \"am_core\"" >> "$TMP_FILE"; \
    echo "config = \"config\"" >> "$TMP_FILE"; \
    echo "logs = \"logs\"" >> "$TMP_FILE"; \
    echo "" >> "$TMP_FILE"; \
    \
    echo "[install]" >> "$TMP_FILE"; \
    echo "root = \"am_install\"" >> "$TMP_FILE"; \
    echo "platforms = \"am_install/lib/platforms\"" >> "$TMP_FILE"; \
    echo "" >> "$TMP_FILE"; \
    \
    echo "[plugins]" >> "$TMP_FILE"; \
    echo "root = \"am_plugins\"" >> "$TMP_FILE"; \
    echo "experimental = \"am_plugins/experimental\"" >> "$TMP_FILE"; \
    echo "official = \"am_plugins/official\"" >> "$TMP_FILE"; \
    echo "user = \"am_plugins/user\"" >> "$TMP_FILE"; \
    echo "" >> "$TMP_FILE"; \
    \
    echo "[i18n]" >> "$TMP_FILE"; \
    echo "root = \"i18n\"" >> "$TMP_FILE"; \
    echo "en_experimental = \"i18n/en/experimental\"" >> "$TMP_FILE"; \
    echo "en_official = \"i18n/en/official\"" >> "$TMP_FILE"; \
    echo "en_user = \"i18n/en/user\"" >> "$TMP_FILE"; \
    echo "pl_experimental = \"i18n/pl/experimental\"" >> "$TMP_FILE"; \
    echo "pl_official = \"i18n/pl/official\"" >> "$TMP_FILE"; \
    echo "pl_user = \"i18n/pl/user\"" >> "$TMP_FILE"; \
    \
    if [ -f "$TARGET" ]; then \
        echo "⚠️  Plik config/ambero_paths.toml już istnieje."; \
        echo -n "🤔 Czy chcesz go nadpisać i zobaczyć podsumowanie zmian? [y/N]: "; \
        read -r CONFIRM < /dev/tty; \
        if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then \
            echo "❌ Anulowano. Plik pozostał bez zmian."; \
            rm "$TMP_FILE"; \
            exit 0; \
        fi; \
        \
        echo ""; \
        echo "📊 PODSUMOWANIE ZMIAN W CONFIGU:"; \
        echo "-------------------------------------"; \
        \
        FLAT_OLD=$(mktemp); \
        FLAT_NEW=$(mktemp); \
        \
        awk '\''/^\[/{sec=$0; next} /=/{print sec " " $0}'\'' "$TARGET" | tr -d "[] " > "$FLAT_OLD"; \
        awk '\''/^\[/{sec=$0; next} /=/{print sec " " $0}'\'' "$TMP_FILE" | tr -d "[] " > "$FLAT_NEW"; \
        \
        while IFS= read -r line || [ -n "$line" ]; do \
            [[ -z "$line" ]] && continue; \
            sec_key=$(echo "$line" | cut -d"=" -f1); \
            val=$(echo "$line" | cut -d"=" -f2-); \
            display_key=$(echo "$sec_key" | cut -d"." -f2); \
            \
            if grep -q "^$sec_key=" "$FLAT_OLD"; then \
                old_val=$(grep "^$sec_key=" "$FLAT_OLD" | cut -d"=" -f2-); \
                if [ "$old_val" = "$val" ]; then \
                    echo "⚪ [BEZ ZMIAN]  $display_key = $val"; \
                else \
                    echo "🟡 [ZMIENIONO] $display_key: $old_val ➡️  $val"; \
                fi; \
            else \
                echo "🟢 [DODANO]    $display_key = $val"; \
            fi; \
        done < "$FLAT_NEW"; \
        \
        while IFS= read -r line || [ -n "$line" ]; do \
            [[ -z "$line" ]] && continue; \
            sec_key=$(echo "$line" | cut -d"=" -f1); \
            display_line=$(echo "$line" | cut -d"." -f2- | sed '\''s/=/ = /'\''); \
            if ! grep -q "^$sec_key=" "$FLAT_NEW"; then \
                echo "🔴 [USUNIĘTO]   $display_line"; \
            fi; \
        done < "$FLAT_OLD"; \
        \
        rm "$FLAT_OLD" "$FLAT_NEW"; \
        echo "-------------------------------------"; \
    else \
        echo ""; \
        echo "✨ Tworzenie nowego pliku konfiguracji..."; \
        echo "📊 PODSUMOWANIE (Nowy plik):"; \
        echo "-------------------------------------"; \
        grep -v "^$" "$TMP_FILE" | grep -v "^\[" | sed "s/^/🟢 [DODANO]    /"; \
        echo "-------------------------------------"; \
    fi; \
    \
    mv "$TMP_FILE" "$TARGET"; \
    echo "✅ Gotowe! Zapisano w: config/ambero_paths.toml"; \
    '
    @just dir-view


# Drukuje zmapowane sekcje i ścieżki z pliku ambero_paths.toml w czytelny sposób
[no-cd]
dir-view:
    @bash -c ' \
    TARGET="{{AMBERO_DIR}}/config/ambero_paths.toml"; \
    if [ ! -f "$TARGET" ]; then \
        echo "❌ Błąd: Plik konfiguracyjny nie istnieje!"; \
        echo "👉 Uruchom najpierw: just create_dir"; \
        exit 1; \
    fi; \
    \
    echo -e "\n📂 STRUKTURA ŚCIEŻEK FRAMEWORKU AMBERO:"; \
    echo "=================================================="; \
    \
    while IFS= read -r line || [ -n "$line" ]; do \
        if [[ "$line" =~ ^\[.*\]$ ]]; then \
            section=$(echo "$line" | tr -d "[]" | tr "[:lower:]" "[:upper:]"); \
            echo -e "\n🔷 SEKCJA: $section"; \
            echo "--------------------------------------------------"; \
        elif [[ "$line" =~ = ]]; then \
            key=$(echo "$line" | cut -d"=" -f1 | tr -d " "); \
            val=$(echo "$line" | cut -d"=" -f2- | tr -d "\"" | sed -e "s/^[[:space:]]*//" -e "s/[[:space:]]*$//"); \
            printf "  ├── \x1b[36m%-20s\x1b[0m ➡️  \x1b[32m%s\x1b[0m\n" "$key" "$val"; \
        fi; \
    done < "$TARGET"; \
    echo -e "==================================================\n"; \
    '
