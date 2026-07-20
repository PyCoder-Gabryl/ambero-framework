# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator mapy ścieżek frameworku. Odpowiada za
#                   tworzenie i aktualizację pliku ambero_paths.toml,
#                   który służy jako centralny rejestr lokalizacji
#                   modułów, wtyczek i plików konfiguracyjnych.
# ----------------------------------------------------------------------------
# PATH:            am_just/ambero_dir.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================

# Generuje lub aktualizuje plik konfiguracyjny ze ścieżkami w am_config/ambero_paths.toml
[no-cd]
map-paths:
    @echo "🚀 Inicjalizacja mapowania ścieżek frameworku..."
    @mkdir -p "{{AMBERO_DIR}}/am_config"
    @mkdir -p "{{AMBERO_DIR}}/logs"
    @bash -c ' \
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"; \
    HEADER_TMPL="{{AMBERO_DIR}}/am_config/templates/header_generated.txt"; \
    TMP_FILE=$(mktemp); \
    GEN_DATE=$(date "+%Y-%m-%d %H:%M:%S"); \
    DESC="Automatyczny rejestr ścieżek systemowych frameworku Ambero."; \
    \
    # 1. Generowanie nagłówka z szablonu \
    if [ -f "$HEADER_TMPL" ]; then \
        sed -e "s/{{PROJECT_NAME}}/AMBERO FRAMEWORK CLI/g" \
            -e "s/{{GEN_DATE}}/$GEN_DATE/g" \
            -e "s/{{DESCRIPTION}}/$DESC/g" \
            -e "s|{{FILE_PATH}}|am_config/ambero_paths.toml|g" \
            "$HEADER_TMPL" > "$TMP_FILE"; \
    else \
        echo "# Generated: $GEN_DATE" > "$TMP_FILE"; \
    fi; \
    \
    # 2. Generowanie treści TOML \
    { \
        echo -e "\n[system]"; \
        echo "core = \"am_core\""; \
        echo "config = \"am_config\""; \
        echo "logs = \"logs\""; \
        echo -e "\n[install]"; \
        echo "root = \"am_install\""; \
        echo "platforms = \"am_install/lib/platforms\""; \
        echo -e "\n[plugins]"; \
        echo "root = \"am_plugins\""; \
        echo "experimental = \"am_plugins/experimental\""; \
        echo "official = \"am_plugins/official\""; \
        echo "user = \"am_plugins/user\""; \
        echo -e "\n[i18n]"; \
        echo "root = \"i18n\""; \
        echo "en_experimental = \"i18n/en/experimental\""; \
        echo "en_official = \"i18n/en/official\""; \
        echo "en_user = \"i18n/en/user\""; \
        echo "pl_experimental = \"i18n/pl/experimental\""; \
        echo "pl_official = \"i18n/pl/official\""; \
        echo "pl_user = \"i18n/pl/user\""; \
    } >> "$TMP_FILE"; \
    \
    if [ -f "$TARGET" ]; then \
        echo "⚠️  Plik am_config/ambero_paths.toml już istnieje."; \
        echo -n "🤔 Czy chcesz go nadpisać i zobaczyć zmiany? [y/N]: "; \
        read -r CONFIRM < /dev/tty; \
        [[ ! "$CONFIRM" =~ ^[Yy]$ ]] && { echo "❌ Anulowano."; rm "$TMP_FILE"; exit 0; }; \
        \
        echo -e "\n📊 PODSUMOWANIE ZMIAN:"; \
        echo "-------------------------------------"; \
        FLAT_OLD=$(mktemp); FLAT_NEW=$(mktemp); \
        awk '\''/^\[/{sec=$0; next} /=/{print sec " " $0}'\'' "$TARGET" | tr -d "[] " > "$FLAT_OLD"; \
        awk '\''/^\[/{sec=$0; next} /=/{print sec " " $0}'\'' "$TMP_FILE" | tr -d "[] " > "$FLAT_NEW"; \
        \
        while IFS= read -r line || [ -n "$line" ]; do \
            [[ -z "$line" ]] && continue; \
            sec_key=$(echo "$line" | cut -d"=" -f1); \
            val=$(echo "$line" | cut -d"=" -f2-); \
            display_key=$(echo "$sec_key" | cut -d"." -f2); \
            if grep -q "^$sec_key=" "$FLAT_OLD"; then \
                old_val=$(grep "^$sec_key=" "$FLAT_OLD" | cut -d"=" -f2-); \
                if [ "$old_val" != "$val" ]; then \
                    echo "🟡 [ZMIENIONO] $display_key: $old_val ➡️  $val"; \
                fi; \
            else \
                echo "🟢 [DODANO]    $display_key = $val"; \
            fi; \
        done < "$FLAT_NEW"; \
        rm "$FLAT_OLD" "$FLAT_NEW"; \
        echo "-------------------------------------"; \
    fi; \
    \
    mv "$TMP_FILE" "$TARGET"; \
    echo "✅ Gotowe! Zapisano w: am_config/ambero_paths.toml"; \
    '
    @just dir-view

# Drukuje zmapowane sekcje i ścieżki z pliku ambero_paths.toml w czytelny sposób
[no-cd]
dir-view:
    @bash -c ' \
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"; \
    if [ ! -f "$TARGET" ]; then \
        echo "❌ Błąd: Plik konfiguracyjny nie istnieje!"; \
        echo "👉 Uruchom najpierw: just map-paths"; \
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
