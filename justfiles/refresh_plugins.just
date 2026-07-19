# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Automatyczny skaner i rejestrator wtyczek (plugins).
#                   Przeszukuje katalog am_plugins, generuje zadania Just
#                   i zarządza symlinkami rdzenia dla izolacji wtyczek.
#                   Obsługuje głębokie skanowanie podkatalogów dostawców.
# ----------------------------------------------------------------------------
# PATH:            just_lib/refresh_plugins.just
# VERSION:         0.1.1
# CREATED:         2026-07-19
# ============================================================================

# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
refresh-plugins:
    @echo "🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero..."
    @bash -c ' \
    shopt -s nullglob; \
    OUT="{{AMBERO_DIR}}/am_plugins/plugins.just"; \
    OLD_TARGETS=$(grep -E "^[a-zA-Z0-9_-]+:" "$OUT" 2>/dev/null | cut -d: -f1 | tr "\n" " "); \
    \
    echo "# ============================================================================" > "$OUT"; \
    echo "# PROJECT:         Ambero Framework CLI" >> "$OUT"; \
    echo "# DESCRIPTION:     Automatycznie wygenerowany rejestr wtyczek." >> "$OUT"; \
    echo "#                  UWAGA: Ten plik jest generowany automatycznie." >> "$OUT"; \
    echo "#                  Ręczne zmiany zostaną nadpisane przy odświeżeniu!" >> "$OUT"; \
    echo "# ----------------------------------------------------------------------------" >> "$OUT"; \
    echo "# PATH:            am_plugins/plugins.just" >> "$OUT"; \
    echo "# ============================================================================" >> "$OUT"; \
    echo "" >> "$OUT"; \
    \
    P_CNT=0; T_COUNT=0; \
    for t in official experimental user; do \
        DIR="{{AMBERO_DIR}}/am_plugins/$t"; \
        printf "\n{{clr_b_purple}}📂 [FOLDER TYPU]: am_plugins/%s{{style_reset}}\n" "$t"; \
        if [ ! -d "$DIR" ]; then \
            printf "  ⚠️  Katalog nie istnieje: %s\n" "$DIR"; \
            continue; \
        fi; \
        V_LIST=("$DIR"/*); \
        if [ ${#V_LIST[@]} -eq 0 ]; then \
            printf "  {{clr_yellow}}📂 (Katalog typów jest pusty){{style_reset}}\n"; \
        fi; \
        for v in "${V_LIST[@]}"; do \
            [ ! -d "$v" ] && continue; \
            v_nm=$(basename "$v"); \
            printf "  ├── 🏢 [SPRAWDZAM DOSTAWCĘ]: {{clr_b_blue}}%s{{style_reset}}\n" "$v_nm"; \
            \
            # Głębokie szukanie plików .ab wewnątrz dostawcy \
            F_LIST=($(find "$v" -type f -name "*.ab")); \
            if [ ${#F_LIST[@]} -eq 0 ]; then \
                printf "  │            {{clr_yellow}}📂 (Katalog dostawcy jest pusty){{style_reset}}\n"; \
            fi; \
            for f in "${F_LIST[@]}"; do \
                f_nm=$(basename "$f"); \
                rel_f=${f#{{AMBERO_DIR}}/\}; \
                rel_dir=$(dirname "$rel_f"); \
                \
                if ! grep -q "main[[:space:]]*{" "$f"; then \
                    printf "  │   ├── {{clr_yellow}}ℹ️  [NIE JEST WTYCZKĄ]: %s{{style_reset}}\n" "$f_nm"; \
                    continue; \
                fi; \
                \
                INFO=$(awk '\''BEGIN{IGNORECASE=1} /HELP-INFO/{sub(/^.*HELP-INFO[[:space:]]*:?[[:space:]]*/, ""); \
                    print; exit}'\'' "$f" | sed -E "s/^[[:space:]]*//; s/[[:space:]]*$//"); \
                \
                raw_base="${f_nm%.ab}"; \
                [[ "$f_nm" == *_test.ab ]] && raw_base="${f_nm%_test.ab}"; \
                base=$(echo "$raw_base" | tr "_" "-"); \
                [[ "$f_nm" == *_test.ab ]] && base="${base}-test"; \
                \
                IS_NEW=""; [[ ! " $OLD_TARGETS " =~ " $base " ]] && IS_NEW=" {{clr_b_green}}[NOWA]{{style_reset}}"; \
                \
                if [[ "$f_nm" == *_test.ab ]]; then \
                    [ -z "$INFO" ] && INFO="Test wtyczki: ${f_nm}"; \
                    printf "  │   ├── 🧪 [WYKRYTO TEST]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                        "$f_nm" "$base" "$IS_NEW"; \
                    T_COUNT=$((T_COUNT + 1)); \
                else \
                    [ -z "$INFO" ] && INFO="Wtyczka: ${f_nm}"; \
                    printf "  │   ├── 🟢 [WYKRYTO PLIK]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}%s\n" \
                        "$f_nm" "$base" "$IS_NEW"; \
                    P_CNT=$((P_CNT + 1)); \
                fi; \
                \
                echo "# ${INFO}" >> "$OUT"; \
                echo "${base}: _check_config" >> "$OUT"; \
                echo "    @bash -c '\''trap \"rm -rf {{AMBERO_DIR}}/$rel_dir/am_core\" EXIT INT TERM; \\" >> "$OUT"; \
                echo "        ln -sfn {{AMBERO_DIR}}/am_core {{AMBERO_DIR}}/$rel_dir/am_core; \\" >> "$OUT"; \
                echo "        amber run {{AMBERO_DIR}}/$rel_f'\''" >> "$OUT"; \
                echo "" >> "$OUT"; \
            done; \
        done; \
    done; \
    echo "------------------------------------------------------------"; \
    echo "📊 PODSUMOWANIE REJESTRACJI:"; \
    printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"; \
    printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"; \
    echo "------------------------------------------------------------"; \
    echo "✅ Gotowe! Wtyczki dopisane do am_plugins/plugins.just";'
