# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Interaktywny przewodnik dewelopera Ambero.
#                   Dynamicznie wczytuje sekcje pomocy z katalogu dev_help.
# ----------------------------------------------------------------------------
# PATH:            am_just/dev_help.just
# VERSION:         0.1.1
# CREATED:         2026-07-20
# ============================================================================

# Wyświetla interaktywny przewodnik dla deweloperów frameworku Ambero
dev-help:
    #!/usr/bin/env bash
    set -euo pipefail

    HELP_DIR="{{AMBERO_DIR}}/am_just/dev_help"

    # --- FUNKCJA: WYŚWIETLANIE MENU ---
    show_menu() {
        echo -e "\n{{clr_amber}}{{style_bold}}🛠️  AMBERO DEVELOPER GUIDE - MENU GŁÓWNE{{style_reset}}"
        echo -e "------------------------------------------------------------"

        if test ! -d "$HELP_DIR"; then
            echo -e "{{clr_error}}❌ Błąd: Katalog $HELP_DIR nie istnieje.{{style_reset}}"
            return 1
        fi

        # Dynamiczne wykrywanie plików sekcji s1, s2...
        local files=("$HELP_DIR"/dev_help_s*.txt)
        if test ${#files[@]} -eq 0 || test ! -e "${files[0]}"; then
            echo -e "{{clr_warn}}⚠️  Brak dostępnych sekcji pomocy w $HELP_DIR.{{style_reset}}"
            return 0
        fi

        for f in "${files[@]}"; do
            local fname=$(basename "$f")
            local s_num=$(echo "$fname" | grep -oE "[0-9]+")
            # Wyciąganie tytułu z pierwszej linii pliku
            local title=$(head -n 1 "$f" | sed 's/^# //')
            echo -e "{{clr_info}}$s_num){{style_reset}} $title"
        done
        echo -e "{{clr_red}}q){{style_reset}} Wyjście"
    }

    # --- PĘTLA INTERAKTYWNA ---
    while true; do
        show_menu
        echo -ne "\n{{clr_amber}}👉 Wybierz sekcję [1-9] lub q: {{style_reset}}"
        read -r choice < /dev/tty

        if [[ "$choice" == "q" ]]; then
            echo -e "{{clr_info}}👋 Powodzenia w kodowaniu!{{style_reset}}"
            break
        fi

        FILE="$HELP_DIR/dev_help_s${choice}.txt"
        if test -f "$FILE"; then
            if test -s "$FILE"; then
                clear
                echo -e "{{clr_b_blue}}--- SEKCJA $choice ---{{style_reset}}\n"
                cat "$FILE"
                echo -e "\n{{clr_b_blue}}-------------------{{style_reset}}"
                echo -ne "{{clr_warn}}Naciśnij ENTER, aby wrócić do menu...{{style_reset}}"
                read -r _ < /dev/tty
            else
                echo -e "{{clr_warn}}⚠️  Sekcja $choice jest pusta.{{style_reset}}"
            fi
        else
            echo -e "{{clr_error}}❌ Nieprawidłowy wybór.{{style_reset}}"
        fi
    done
