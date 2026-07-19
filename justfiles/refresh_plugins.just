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
# ============================================================================

# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
refresh-plugins:
    @echo "🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero..."
    @bash -c ' \
    shopt -s nullglob; \
    OUT="{{AMBERO_DIR}}/am_plugins/plugins.just"; \
    # Pobieramy listę starych targetów, aby wykryć nowości \
    OLD_TARGETS=$(grep -E "^[a-zA-Z0-9_-]+:" "$OUT" 2>/dev/null | cut -d: -f1 | tr "\n" " "); \
    \
    # Generowanie nagłówka pliku wynikowego \
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
        [ ! -d "$DIR" ] && { printf "  ⚠️  Katalog nie istnieje\n"; continue; }; \
        \
        # Głębokie skanowanie plików .ab za pomocą find \
        find "$DIR" -type f -name "*.ab" | sort | while read -r f; do \
            # Wykluczamy pliki, które nie mają funkcji main \
            grep -q "main[[:space:]]*{" "$f" || continue; \
            \
            f_nm=$(basename "$f"); \
            rel_f=${f#{{AMBERO_DIR}}/\}; \
            rel_dir=$(dirname "$rel_f"); \
            \
            # Wyciąganie HELP-INFO \
            INFO=$(awk '\''BEGIN{IGNORECASE=1} /HELP-INFO/{sub(/^.*HELP-INFO[[:space:]]*:?[[:space:]]*/, ""); \
                print; exit}'\'' "$f" | sed -E "s/^[[:space:]]*//; s/[[:space:]]*$//"); \
            \
            # Ustalanie nazwy targetu (zamiana _ na -) \
            raw_base="${f_nm%.ab}"; \
            [[ "$f_nm" == *_test.ab ]] && raw_base="${f_nm%_test.ab}"; \
            base=$(echo "$raw_base" | tr "_" "-"); \
            [[ "$f_nm" == *_test.ab ]] && base="${base}-test"; \
            \
            # Sprawdzanie czy wtyczka jest nowa \
            IS_NEW=""; [[ ! " $OLD_TARGETS " =~ " $base " ]] && IS_NEW=" {{clr_b_green}}[NOWA]{{style_reset}}"; \
            \
            # Wyświetlanie statusu w terminalu \
            printf "  ├── 🟢 [WYKRYTO]: %-30s ➡️  {{clr_green}}%s{{style_reset}}%s\n" "$f_nm" "$base" "$IS_NEW"; \
            \
            # Zapisywanie zadania do plugins.just z mechanizmem trap dla bezpieczeństwa \
            [ -z "$INFO" ] && INFO="Wtyczka: ${f_nm}"; \
            echo "# ${INFO}" >> "$OUT"; \
            echo "${base}: _check_config" >> "$OUT"; \
            echo "    @bash -c '\''trap \"rm -rf {{AMBERO_DIR}}/$rel_dir/am_core\" EXIT INT TERM; \\" >> "$OUT"; \
            echo "        ln -sfn {{AMBERO_DIR}}/am_core {{AMBERO_DIR}}/$rel_dir/am_core; \\" >> "$OUT"; \
            echo "        amber run {{AMBERO_DIR}}/$rel_f'\''" >> "$OUT"; \
            echo "" >> "$OUT"; \
            \
            [[ "$f_nm" == *_test.ab ]] && T_COUNT=$((T_COUNT + 1)) || P_CNT=$((P_CNT + 1)); \
        done; \
    done; \
    echo "------------------------------------------------------------"; \
    echo "📊 PODSUMOWANIE REJESTRACJI:"; \
    printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"; \
    printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"; \
    echo "------------------------------------------------------------"; \
    echo "✅ Gotowe! Rejestr: am_plugins/plugins.just";'
