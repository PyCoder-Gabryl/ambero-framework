# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Automatyczny skaner i rejestrator wtyczek (plugins).
#                   Przeszukuje katalog am_plugins, generuje zadania Just
#                   i zarządza symlinkami rdzenia dla izolacji wtyczek.
# ----------------------------------------------------------------------------
# PATH:            am_just/refresh_plugins.just
# VERSION:         0.2.0
# CREATED:         2026-07-19
# ============================================================================

# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
[no-cd]
refresh-plugins:
    #!/usr/bin/env bash
    set -euo pipefail

    echo -e "{{clr_info}}🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero...{{style_reset}}"

    # --- KONFIGURACJA ŚCIEŻEK ---
    AMBERO_DIR="{{AMBERO_DIR}}"
    OUT_FILE="$AMBERO_DIR/am_plugins/plugins.just"
    TMP_REG=$(mktemp)

    # Pobieramy listę starych zadań do wykrywania nowości
    OLD_TARGETS=""
    test -f "$OUT_FILE" && OLD_TARGETS=$(grep -E "^[a-zA-Z0-9_-]+:" "$OUT_FILE" | cut -d: -f1 | tr "\n" " ")

    # --- GENEROWANIE NAGŁÓWKA REJESTRU ---
    # [EDU] Plik plugins.just jest generowany automatycznie. Nagłówek zawiera
    #       ostrzeżenie, aby użytkownik nie edytował go ręcznie.
    cat <<EOF > "$TMP_REG"
# ============================================================================
# PROJECT:         AMBERO FRAMEWORK CLI
# GENERATED:       $(date "+%Y-%m-%d %H:%M:%S")
# DESCRIPTION:     Automatycznie wygenerowany rejestr wtyczek.
# ----------------------------------------------------------------------------
# !!! UWAGA: PLIK GENEROWANY AUTOMATYCZNIE - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: AUTOMATICALLY GENERATED FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

EOF

    P_CNT=0
    T_COUNT=0

    # --- PROCES SKANOWANIA ---
    for type in official experimental user; do
        TYPE_DIR="$AMBERO_DIR/am_plugins/$type"
        printf "\n{{clr_b_purple}}📂 [FOLDER TYPU]: am_plugins/%s{{style_reset}}\n" "$type"

        if test ! -d "$TYPE_DIR"; then
            printf "  {{clr_warn}}⚠️  Katalog nie istnieje: %s{{style_reset}}\n" "$type"
            continue
        fi

        # Skanowanie dostawców (np. ambero, jetbrains)
        for vendor_path in "$TYPE_DIR"/*; do
            test ! -d "$vendor_path" && continue
            vendor_name=$(basename "$vendor_path")
            printf "  ├── 🏢 [SPRAWDZAM DOSTAWCĘ]: {{clr_b_blue}}%s{{style_reset}}\n" "$vendor_name"

            # Głębokie szukanie plików .ab (dowolna głębokość podkatalogów)
            mapfile -t AB_FILES < <(find "$vendor_path" -type f -name "*.ab" | sort)

            if [ ${#AB_FILES[@]} -eq 0 ]; then
                printf "  │            {{clr_yellow}}📂 (Katalog dostawcy jest pusty){{style_reset}}\n"
            fi

            for f_path in "${AB_FILES[@]}"; do
                f_name=$(basename "$f_path")
                # Ścieżka relatywna względem AMBERO_DIR dla Justa
                rel_f_path=${f_path#$AMBERO_DIR/}
                rel_f_dir=$(dirname "$rel_f_path")

                # Weryfikacja czy plik jest wtyczką (musi mieć main {})
                if ! grep -q "main[[:space:]]*{" "$f_path"; then
                    printf "  │   ├── {{clr_yellow}}ℹ️  [NIE JEST WTYCZKĄ]: %s{{style_reset}}\n" "$f_name"
                    continue
                fi

                # Ekstrakcja opisu HELP-INFO
                INFO=$(awk 'BEGIN{IGNORECASE=1} /HELP-INFO/{sub(/^.*HELP-INFO[[:space:]]*:?[[:space:]]*/, ""); \
                    print; exit}' "$f_path" | sed -E "s/^[[:space:]]*//; s/[[:space:]]*$//")

                # Budowanie nazwy zadania (slug)
                raw_base="${f_name%.ab}"
                [[ "$f_name" == *_test.ab ]] && raw_base="${f_name%_test.ab}"
                target_name=$(echo "$raw_base" | tr "_" "-")
                [[ "$f_name" == *_test.ab ]] && target_name="${target_name}-test"

                # Wykrywanie nowości
                IS_NEW=""
                [[ ! " $OLD_TARGETS " =~ " $target_name " ]] && IS_NEW=" {{clr_b_green}}[NOWA]{{style_reset}}"

                # Raportowanie do terminala
                if [[ "$f_name" == *_test.ab ]]; then
                    printf "  │   ├── 🧪 [WYKRYTO TEST]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                        "$f_name" "$target_name" "$IS_NEW"
                    T_COUNT=$((T_COUNT + 1))
                else
                    printf "  │   ├── 🟢 [WYKRYTO PLIK]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                        "$f_name" "$target_name" "$IS_NEW"
                    P_CNT=$((P_CNT + 1))
                fi

                # --- GENEROWANIE ZADANIA JUST ---
                # [EDU] Każda wtyczka otrzymuje własny symlink am_core w swoim katalogu.
                #       Mechanizm 'trap' gwarantuje usunięcie symlinka nawet przy błędzie.
                [ -z "$INFO" ] && INFO="Wtyczka: $f_name"
                echo "# $INFO" >> "$TMP_REG"
                echo "$target_name: _check_config" >> "$TMP_REG"
                echo "    @bash -c 'trap \"rm -f \$PWD/$rel_f_dir/am_core\" EXIT INT TERM; \\" >> "$TMP_REG"
                echo "        ln -sfn {{AMBERO_DIR}}/am_core \"\$PWD/$rel_f_dir/am_core\"; \\" >> "$TMP_REG"
                echo "        amber run \"\$PWD/$rel_f_path\"'" >> "$TMP_REG"
                echo "" >> "$TMP_REG"
            done
        done
    done

    # --- FINALIZACJA (ZAPIS ATOMOWY) ---
    mv "$TMP_REG" "$OUT_FILE"

    echo "------------------------------------------------------------"
    echo -e "📊 PODSUMOWANIE REJESTRACJI:"
    printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"
    printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"
    echo "------------------------------------------------------------"
    echo -e "{{clr_success}}✅ Gotowe! Rejestr: am_plugins/plugins.just{{style_reset}}"
