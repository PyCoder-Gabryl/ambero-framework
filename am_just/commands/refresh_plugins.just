# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Zaawansowany skaner i rejestrator wtyczek (plugins).
#                   Przeszukuje katalog am_plugins, generuje zadania Just
#                   i zarządza symlinkami rdzenia dla izolacji wtyczek.
#                   Wersja 0.2.4: Integracja z wrapperem UI i fix błędu grep.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/refresh_plugins.just
# VERSION:         0.2.4
# CREATED:         2026-07-19
# ============================================================================

# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
refresh-plugins:
    @just _run-just "_refresh-plugins-logic" "refresh-plugins"

# --- LOGIKA WEWNĘTRZNA (UKRYTA) ---

[private]
[no-cd]
_refresh-plugins-logic:
    #!/usr/bin/env bash
    set -euo pipefail

    echo -e "{{clr_info}}🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero...{{style_reset}}"

    # --- KONFIGURACJA ŚCIEŻEK ---
    AMBERO_DIR="{{AMBERO_DIR}}"
    OUT_FILE="$AMBERO_DIR/am_plugins/plugins.just"
    TMP_REG=$(mktemp)

    # [ZMIANA] Dodano || true, aby grep nie wywalał skryptu, gdy nie znajdzie zadań
    OLD_TARGETS=$(grep -E "^[a-zA-Z0-9_-]+:" "$OUT_FILE" 2>/dev/null | cut -d: -f1 | tr "\n" " ") || true

    # --- GENEROWANIE NAGŁÓWKA REJESTRU ---
    printf "# ============================================================================\n" > "$TMP_REG"
    printf "# PROJECT:         AMBERO FRAMEWORK CLI\n" >> "$TMP_REG"
    printf "# GENERATED:       $(date "+%Y-%m-%d %H:%M:%S")\n" >> "$TMP_REG"
    printf "# DESCRIPTION:     Automatycznie wygenerowany rejestr wtyczek.\n" >> "$TMP_REG"
    printf "# ----------------------------------------------------------------------------\n" >> "$TMP_REG"
    printf "# !!! UWAGA: PLIK GENEROWANY AUTOMATYCZNIE - NIE EDYTUJ RĘCZNIE !!!\n" >> "$TMP_REG"
    printf "# !!! WARNING: AUTOMATICALLY GENERATED FILE - DO NOT EDIT MANUALLY !!!\n" >> "$TMP_REG"
    printf "# ============================================================================\n\n" >> "$TMP_REG"

    P_CNT=0
    T_COUNT=0

    # --- PROCES SKANOWANIA ---
    for type in official experimental user; do
        TYPE_DIR="$AMBERO_DIR/am_plugins/$type"
        printf "\n{{clr_b_purple}}📂 [FOLDER TYPU]: am_plugins/%s{{style_reset}}\n" "$type"

        if test ! -d "$TYPE_DIR"; then
            printf "  {{clr_yellow}}📂 (Katalog typów nie istnieje){{style_reset}}\n"
            continue
        fi

        for vendor_path in "$TYPE_DIR"/*; do
            if test -d "$vendor_path"; then
                vendor_name=$(basename "$vendor_path")
                printf "  ├── 🏢 [SPRAWDZAM DOSTAWCĘ]: {{clr_b_blue}}%s{{style_reset}}\n" "$vendor_name"

                FOUND_FILES=$(find "$vendor_path" -type f -name "*.ab" | sort)

                if test -z "$FOUND_FILES"; then
                    printf "  │            {{clr_yellow}}📂 (Katalog dostawcy jest pusty){{style_reset}}\n"
                fi

                echo "$FOUND_FILES" | while read -r f_path; do
                    test -z "$f_path" && continue
                    f_name=$(basename "$f_path")
                    rel_f_path=$(echo "$f_path" | sed "s|$AMBERO_DIR/||")

                    if ! grep -q "main[[:space:]]*{" "$f_path"; then
                        printf "  │   ├── {{clr_yellow}}ℹ️  [NIE JEST WTYCZKĄ]: %s{{style_reset}}\n" "$f_name"
                        continue
                    fi

                    INFO=$(awk 'BEGIN{IGNORECASE=1} /HELP-INFO/{sub(/^.*HELP-INFO[[:space:]]*:?[[:space:]]*/, ""); \
                        print; exit}' "$f_path" | sed -E "s/^[[:space:]]*//; s/[[:space:]]*$//")

                    raw_base="${f_name%.ab}"
                    test "$f_name" != "${f_name%_test.ab}" && raw_base="${f_name%_test.ab}"
                    target_name=$(echo "$raw_base" | tr "_" "-")
                    test "$f_name" != "${f_name%_test.ab}" && target_name="${target_name}-test"

                    IS_NEW=""
                    if [[ " $OLD_TARGETS " != *" $target_name "* ]]; then
                        IS_NEW=" {{clr_b_green}}[NOWA]{{style_reset}}"
                    fi

                    if test "$f_name" != "${f_name%_test.ab}"; then
                        printf "  │   ├── 🧪 [WYKRYTO TEST]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                            "$f_name" "$target_name" "$IS_NEW"
                        T_COUNT=$((T_COUNT + 1))
                    else
                        printf "  │   ├── 🟢 [WYKRYTO PLIK]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                            "$f_name" "$target_name" "$IS_NEW"
                        P_CNT=$((P_CNT + 1))
                    fi

                    test -z "$INFO" && INFO="Wtyczka: $f_name"
                    printf "# %s\n" "$INFO" >> "$TMP_REG"
                    printf "%s:\n" "$target_name" >> "$TMP_REG"
                    printf "    @just _run-amber \"%s\"\n\n" "$rel_f_path" >> "$TMP_REG"
                done
            fi
        done
    done

    mv "$TMP_REG" "$OUT_FILE"

    echo "------------------------------------------------------------"
    echo -e "📊 PODSUMOWANIE REJESTRACJI:"
    printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"
    printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"
    echo "------------------------------------------------------------"
    echo -e "{{clr_success}}✅ Gotowe! Rejestr: am_plugins/plugins.just{{style_reset}}"
