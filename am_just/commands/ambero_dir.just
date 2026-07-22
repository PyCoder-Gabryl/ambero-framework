# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator mapy ścieżek frameworku. Odpowiada za
#                   tworzenie i aktualizację pliku ambero_paths.toml.
#                   Wersja 0.2.5: Pełna integracja z wrapperem UI.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/ambero_dir.just
# VERSION:         0.2.6
# CREATED:         2026-07-20
# ============================================================================


map-paths:
    @just _run-just "_map-paths-logic" "map-paths"

dir-view:
    @just _run-just "_dir-view-logic" "dir-view"

# --- LOGIKA WEWNĘTRZNA (UKRYTA) ---

[private]
[no-cd]
_map-paths-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🚀 Inicjalizacja mapowania ścieżek frameworku..."
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"
    HEADER_TMPL="{{AMBERO_DIR}}/am_config/templates/header_generated.txt"
    TMP_FILE=$(mktemp)
    GEN_DATE=$(date "+%Y-%m-%d %H:%M:%S")
    DESC="Automatyczny rejestr ścieżek systemowych frameworku Ambero."

    if test -f "$HEADER_TMPL"; then
        sed -e "s/{{ "{{" }}PROJECT_NAME}}/{{AMBERO_NAME}}/g" \
            -e "s/{{ "{{" }}GEN_DATE}}/$GEN_DATE/g" \
            -e "s/{{ "{{" }}DESCRIPTION}}/$DESC/g" \
            -e "s/{{ "{{" }}VERSION}}/{{AMBERO_VERSION}}/g" \
            -e "s|{{ "{{" }}FILE_PATH}}|am_config/ambero_paths.toml|g" \
            "$HEADER_TMPL" > "$TMP_FILE"
    else
        echo "# Generated: $GEN_DATE" > "$TMP_FILE"
    fi

    printf "\n[system]\ncore = \"am_core\"\nconfig = \"am_config\"\nlogs = \"logs\"\n" >> "$TMP_FILE"
    printf "\n[install]\nroot = \"am_install\"\nplatforms = \"am_install/lib/platforms\"\n" >> "$TMP_FILE"
    printf "\n[just]\nroot = \"am_just\"\ncommands = \"am_just/commands\"\nlib = \"am_just/lib\"\n" >> "$TMP_FILE"
    printf "\n[plugins]\nroot = \"am_plugins\"\nexperimental = \"am_plugins/experimental\"\n" >> "$TMP_FILE"
    printf "official = \"am_plugins/official\"\nuser = \"am_plugins/user\"\n" >> "$TMP_FILE"
    printf "\n[i18n]\nroot = \"i18n\"\nen_experimental = \"i18n/en/experimental\"\n" >> "$TMP_FILE"
    printf "en_official = \"i18n/en/official\"\nen_user = \"i18n/en/user\"\n" >> "$TMP_FILE"
    printf "pl_experimental = \"i18n/pl/experimental\"\npl_official = \"i18n/pl/official\"\n" >> "$TMP_FILE"
    printf "pl_user = \"i18n/pl/user\"\n" >> "$TMP_FILE"

    if test -f "$TARGET"; then
        echo "⚠️  Plik am_config/ambero_paths.toml już istnieje."
        echo -n "🤔 Czy chcesz go nadpisać i zobaczyć zmiany? [y/N]: "
        read -r CONFIRM < /dev/tty
        if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
            echo "❌ Anulowano."; rm "$TMP_FILE"; exit 0
        fi
        echo -e "\n📊 PODSUMOWANIE ZMIAN W STRUKTURZE:"
        echo "-------------------------------------"
        FLAT_OLD=$(mktemp); FLAT_NEW=$(mktemp)
        awk '!/^#/ && /^\[/{gsub(/[\[\]]/, "", $0); s=$0; next} !/^#/ && /=/{gsub(/[ "]/, "", $0); print s "." $0}' "$TARGET" > "$FLAT_OLD"
        awk '!/^#/ && /^\[/{gsub(/[\[\]]/, "", $0); s=$0; next} !/^#/ && /=/{gsub(/[ "]/, "", $0); print s "." $0}' "$TMP_FILE" > "$FLAT_NEW"
        while IFS= read -r line; do
            key=$(echo "$line" | cut -d= -f1); val=$(echo "$line" | cut -d= -f2)
            if grep -q "^$key=" "$FLAT_OLD"; then
                old_val=$(grep "^$key=" "$FLAT_OLD" | cut -d= -f2)
                if [ "$old_val" = "$val" ]; then echo "⚪ [BEZ ZMIAN]  $key"
                else echo "🟡 [ZMIENIONO] $key: $old_val ➡️  $val"; fi
            else echo "🟢 [NOWY]      $key"; fi
        done < "$FLAT_NEW"
        rm "$FLAT_OLD" "$FLAT_NEW"
        echo "-------------------------------------"
    fi
    mv "$TMP_FILE" "$TARGET"
    echo "✅ Gotowe! Zapisano w: am_config/ambero_paths.toml"
    just _dir-view-logic

[private]
[no-cd]
_dir-view-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"
    if test ! -f "$TARGET"; then
        echo "❌ Błąd: Plik konfiguracyjny nie istnieje!"
        exit 1
    fi
    echo -e "\n📂 STRUKTURA ŚCIEŻEK FRAMEWORKU AMBERO:"
    echo "=================================================="
    while IFS= read -r line || [ -n "$line" ]; do
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$(echo "$line" | tr -d '[:space:]')" ]] && continue
        if [[ "$line" =~ ^\[.*\]$ ]]; then
            section=$(echo "$line" | tr -d "[]" | tr "[:lower:]" "[:upper:]")
            echo -e "\n🔷 SEKCJA: $section"
            echo "--------------------------------------------------"
        elif [[ "$line" =~ = ]]; then
            key=$(echo "$line" | cut -d"=" -f1 | tr -d " ")
            val=$(echo "$line" | cut -d"=" -f2- | tr -d "\"" | sed -e "s/^[[:space:]]*//" -e "s/[[:space:]]*$//")
            printf "  ├── \x1b[36m%-20s\x1b[0m ➡️  \x1b[32m%s\x1b[0m\n" "$key" "$val"
        fi
    done < "$TARGET"
    echo -e "==================================================\n"
