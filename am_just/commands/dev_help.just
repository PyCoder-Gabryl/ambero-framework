# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Interaktywny przewodnik dewelopera Ambero.
#                   Zawiera sztywno zdefiniowane menu nawigacyjne dla
#                   zapewnienia maksymalnej stabilności interfejsu.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/dev_help.just
# VERSION:         0.1.3
# CREATED:         2026-07-20
# ============================================================================

# Wyświetla interaktywny przewodnik dla deweloperów frameworku Ambero
dev-help:
    #!/usr/bin/env bash
    set -euo pipefail

    # --- KONFIGURACJA ---
    HELP_DIR="{{AMBERO_DIR}}/am_just/dev_help"

    # [EDU] Wyświetlamy ekran powitalny (Splash Screen) przed wejściem w pętlę.
    if test -f "$HELP_DIR/dev_help.txt"; then
        clear
        cat "$HELP_DIR/dev_help.txt"
    fi

    # --- GŁÓWNA PĘTLA INTERFEJSU ---
    while true; do
        echo -e "\n{{clr_amber}}{{style_bold}}🛠️  AMBERO DEVELOPER GUIDE - MENU GŁÓWNE{{style_reset}}"
        echo -e "------------------------------------------------------------"
        echo -e "{{clr_info}}1){{style_reset}} ARCHITEKTURA I STRUKTURA KATALOGÓW"
        echo -e "{{clr_info}}2){{style_reset}} TWORZENIE WTYCZEK (PLUGINS)"
        echo -e "{{clr_info}}3){{style_reset}} JUST I INTEGRACJA SYSTEMOWA"
        echo -e "{{clr_info}}4){{style_reset}} INTERFEJS, VERBOSITY I i18n"
        echo -e "{{clr_red}}q){{style_reset}} Wyjście"

        echo -ne "\n{{clr_amber}}👉 Wybierz sekcję [1-4] lub q: {{style_reset}}"
        read -r choice < /dev/tty

        # Obsługa wyjścia
        if [[ "$choice" == "q" ]]; then
            echo -e "{{clr_info}}👋 Powodzenia w rozbudowie Ambero!{{style_reset}}"
            break
        fi

        # Mapowanie wyboru na konkretny plik
        case "$choice" in
            1) FILE="dev_help_s1.txt" ;;
            2) FILE="dev_help_s2.txt" ;;
            3) FILE="dev_help_s3.txt" ;;
            4) FILE="dev_help_s4.txt" ;;
            *)
                echo -e "{{clr_error}}❌ Nieprawidłowy wybór: $choice{{style_reset}}"
                continue
                ;;
        esac

        # --- WYŚWIETLANIE ZAWARTOŚCI ---
        FULL_PATH="$HELP_DIR/$FILE"

        if test -f "$FULL_PATH"; then
            if test -s "$FULL_PATH"; then
                clear
                # Nagłówek sekcji pobrany z pierwszej linii pliku
                SECTION_TITLE=$(head -n 1 "$FULL_PATH" | sed 's/^# //')
                echo -e "{{clr_b_blue}}📘 SEKCJA $choice: $SECTION_TITLE{{style_reset}}"
                echo -e "{{clr_blue}}------------------------------------------------------------{{style_reset}}\n"

                cat "$FULL_PATH"

                echo -e "\n{{clr_blue}}------------------------------------------------------------{{style_reset}}"
                echo -ne "{{clr_warn}}Naciśnij ENTER, aby wrócić do menu...{{style_reset}}"
                read -r _ < /dev/tty
                clear
                # Po powrocie z sekcji ponownie pokazujemy ekran powitalny dla kontekstu
                test -f "$HELP_DIR/dev_help.txt" && cat "$HELP_DIR/dev_help.txt"
            else
                echo -e "{{clr_warn}}⚠️  Plik sekcji $choice istnieje, ale jest pusty.{{style_reset}}"
            fi
        else
            echo -e "{{clr_error}}❌ Błąd: Nie znaleziono pliku $FILE w $HELP_DIR{{style_reset}}"
        fi
    done
