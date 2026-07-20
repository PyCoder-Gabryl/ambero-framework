# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator mapy ścieżek frameworku. Odpowiada za
#                   tworzenie i aktualizację pliku ambero_paths.toml.
#                   Wersja 0.2.3 naprawia błędy parsowania nagłówków.
# ----------------------------------------------------------------------------
# PATH:            am_just/ambero_dir.just
# VERSION:         0.2.3
# CREATED:         2026-07-20
# ============================================================================

# Generuje lub aktualizuje plik konfiguracyjny ze ścieżkami w am_config/ambero_paths.toml
[no-cd]
map-paths:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "🚀 Inicjalizacja mapowania ścieżek frameworku..."

    AMBERO_DIR="{{AMBERO_DIR}}"
    TARGET="$AMBERO_DIR/am_config/ambero_paths.toml"
    HEADER_TMPL="$AMBERO_DIR/am_config/templates/header_generated.txt"
    TMP_FILE=$(mktemp)
    GEN_DATE=$(date "+%Y-%m-%d %H:%M:%S")
    DESC="Automatyczny rejestr ścieżek systemowych frameworku Ambero."

    # --- SEKCJA 1: GENEROWANIE NAGŁÓWKA ---
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

    # --- SEKCJA 2: GENEROWANIE TREŚCI TOML ---
    printf "\n[system]\ncore = \"am_core\"\nconfig = \"am_config\"\nlogs = \"logs\"\n" >> "$TMP_FILE"
    printf "\n[install]\nroot = \"am_install\"\nplatforms = \"am_install/lib/platforms\"\n" >> "$TMP_FILE"
    printf "\n[plugins]\nroot = \"am_plugins\"\nexperimental = \"am_plugins/experimental\"\n" >> "$TMP_FILE"
    printf "official = \"am_plugins/official\"\nuser = \"am_plugins/user\"\n" >> "$TMP_FILE"
    printf "\n[i18n]\nroot = \"i18n\"\nen_experimental = \"i18n/en/experimental\"\n" >> "$TMP_FILE"
    printf "en_official = \"i18n/en/official\"\nen_user = \"i18n/en/user\"\n" >> "$TMP_FILE"
    printf "pl_experimental = \"i18n/pl/experimental\"\npl_official = \"i18n/pl/official\"\n" >> "$TMP_FILE"
    printf "pl_user = \"i18n/pl/user\"\n" >> "$TMP_FILE"

    # --- SEKCJA 3: PORÓWNANIE I AKTUALIZACJA ---
    if test -f "$TARGET"; then
        echo "⚠️  Plik am_config/ambero_paths.toml już istnieje."
        echo -n "🤔 Czy chcesz go nadpisać i zobaczyć zmiany? [y/N]: "
        read -r CONFIRM < /dev/tty
        if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
            echo "❌ Anulowano."
            rm "$TMP_FILE"
            exit 0
        fi

        echo -e "\n📊 PODSUMOWANIE ZMIAN W STRUKTURZE:"
        echo "-------------------------------------"
        FLAT_OLD=$(mktemp)
        FLAT_NEW=$(mktemp)

        # [ZMIANA] Dodano !/^#/ aby ignorować nagłówek podczas porównywania
        awk '!/^#/ && /^\[/{sec=$0; next} !/^#/ && /=/{print sec " " $0}' "$TARGET" | tr -d "[] " > "$FLAT_OLD"
        awk '!/^#/ && /^\[/{sec=$0; next} !/^#/ && /=/{print sec " " $0}' "$TMP_FILE" | tr -d "[] " > "$FLAT_NEW"

        while IFS= read -r line || [ -n "$line" ]; do
            [[ -z "$line" ]] && continue
            sec_key=$(echo "$line" | cut -d"=" -f1)
            val=$(echo "$line" | cut -d"=" -f2-)
            display_key=$(echo "$sec_key" | cut -d"." -f2)
            if grep -q "^$sec_key=" "$FLAT_OLD"; then
                old_val=$(grep "^$sec_key=" "$FLAT_OLD" | cut -d"=" -f2-)
                if [ "$old_val" != "$val" ]; then
                    echo "🟡 [ZMIENIONO] $display_key: $old_val ➡️  $val"
                fi
            else
                echo "🟢 [DODANO]    $display_key = $val"
            fi
        done < "$FLAT_NEW"
        rm "$FLAT_OLD" "$FLAT_NEW"
        echo "-------------------------------------"
    fi

    mv "$TMP_FILE" "$TARGET"
    echo "✅ Gotowe! Zapisano w: am_config/ambero_paths.toml"
    just dir-view

# Drukuje zmapowane sekcje i ścieżki z pliku ambero_paths.toml
[no-cd]
dir-view:
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
        # [ZMIANA] Ignorowanie komentarzy i linii nagłówka
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
