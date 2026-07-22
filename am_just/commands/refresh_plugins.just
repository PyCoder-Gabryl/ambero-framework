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
#                   Wersja 0.2.8: Fix błędu 'print' i poprawa raportowania.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/refresh_plugins.just
# VERSION:         0.2.8
# CREATED:         2026-07-19
# ============================================================================

# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
refresh-plugins:
    @just _run-just "_refresh-plugins-logic" "refresh-plugins"

[private]
[no-cd]
_refresh-plugins-logic:
    #!/usr/bin/env bash
    # [EDU] shopt -s nullglob sprawia, że jeśli wzorzec (np. *) nie znajdzie
    # plików, zwraca pusty ciąg zamiast surowego tekstu gwiazdki.
    shopt -s nullglob
    set -euo pipefail

    # --- INICJALIZACJA ---
    AMBERO_DIR="{{AMBERO_DIR}}"
    OUT_FILE="$AMBERO_DIR/am_plugins/plugins.just"
    TMP_REG=$(mktemp)
    P_CNT=0
    T_COUNT=0
    NEW_CNT=0

    mkdir -p "$AMBERO_DIR/am_plugins"
    echo -e "{{clr_info}}🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero...{{style_reset}}"

    # Pobieramy listę starych zadań do wykrywania nowości
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

    # --- PROCES SKANOWANIA ---
    for type in official experimental user; do
        TYPE_DIR="$AMBERO_DIR/am_plugins/$type"
        printf "\n{{clr_b_purple}}📂 [FOLDER TYPU]: am_plugins/%s{{style_reset}}\n" "$type"

        if test ! -d "$TYPE_DIR"; then
            printf "  {{clr_yellow}}📂 (Katalog typów nie istnieje){{style_reset}}\n"
            continue
        fi

        # Sprawdzenie czy katalog typu jest pusty (używamy tablicy dla pewności)
        V_LIST=("$TYPE_DIR"/*)
        if [ ${#V_LIST[@]} -eq 0 ]; then
            printf "  {{clr_yellow}}📂 (Katalog typów jest pusty){{style_reset}}\n"
            continue
        fi

        for vendor_path in "${V_LIST[@]}"; do
            test ! -d "$vendor_path" && continue
            vendor_name=$(basename "$vendor_path")
            printf "  ├── 🏢 [SPRAWDZAM DOSTAWCĘ]: {{clr_b_blue}}%s{{style_reset}}\n" "$vendor_name"

            # Głębokie szukanie plików .ab
            while read -r f_path; do
                test -z "$f_path" && continue
                f_name=$(basename "$f_path")
                rel_f_path=${f_path#$AMBERO_DIR/}
                rel_f_dir=$(dirname "$rel_f_path")

                if ! grep -q "main[[:space:]]*{" "$f_path"; then
                    printf "  │   ├── {{clr_yellow}}ℹ️  [NIE JEST WTYCZKĄ]: %s{{style_reset}}\n" "$f_name"
                    continue
                fi

                INFO=$(awk 'BEGIN{IGNORECASE=1} /HELP-INFO/{sub(/^.*HELP-INFO[[:space:]]*:?[[:space:]]*/, ""); \
                    print; exit}' "$f_path" | sed -E "s/^[[:space:]]*//; s/[[:space:]]*$//")

                raw_base="${f_name%.ab}"
                [[ "$f_name" == *_test.ab ]] && raw_base="${f_name%_test.ab}"
                target_name=$(echo "$raw_base" | tr "_" "-")
                [[ "$f_name" == *_test.ab ]] && target_name="${target_name}-test"

                IS_NEW=""
                # [EDU] Sprawdzamy czy nazwa zadania jest już w OLD_TARGETS
                if [[ ! " $OLD_TARGETS " =~ " $target_name " ]]; then
                    IS_NEW=" {{clr_b_green}}[NOWA]{{style_reset}}"
                    NEW_CNT=$((NEW_CNT + 1))
                fi

                if [[ "$f_name" == *_test.ab ]]; then
                    printf "  │   ├── 🧪 [WYKRYTO TEST]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                        "$f_name" "$target_name" "$IS_NEW"
                    T_COUNT=$((T_COUNT + 1))
                else
                    printf "  │   ├── 🟢 [WYKRYTO PLIK]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                        "$f_name" "$target_name" "$IS_NEW"
                    P_CNT=$((P_CNT + 1))
                fi

                [ -z "$INFO" ] && INFO="Wtyczka: $f_name"
                printf "# %s\n" "$INFO" >> "$TMP_REG"
                printf "%s: _check_config\n" "$target_name" >> "$TMP_REG"
                printf "    @bash -c 'trap \"rm -f \\\$PWD/%s/am_core\" EXIT INT TERM; \\\\\n" "$rel_f_dir" >> "$TMP_REG"
                printf "        ln -sfn {{AMBERO_DIR}}/am_core \"\\\$PWD/%s/am_core\"; \\\\\n" "$rel_f_dir" >> "$TMP_REG"
                printf "        amber run \"\\\$PWD/%s\"'\n\n" "$rel_f_path" >> "$TMP_REG"

            done < <(find "$vendor_path" -type f -name "*.ab" | sort)
        done
    done

    # --- FINALIZACJA ---
    mv "$TMP_REG" "$OUT_FILE"

    echo "------------------------------------------------------------"
    echo -e "📊 PODSUMOWANIE REJESTRACJI:"
    # [ZMIANA] Poprawiono print na printf (naprawa błędu exit code 127)
    printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"
    printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"
    printf "  • {{clr_amber}}Dodane nowe:{{style_reset}}     %d\n" "$NEW_CNT"
    echo "------------------------------------------------------------"
    echo -e "{{clr_success}}✅ Gotowe! Rejestr: am_plugins/plugins.just{{style_reset}}"
