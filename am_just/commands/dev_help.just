# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Interaktywny przewodnik dewelopera Ambero.
#                   Zapewnia dostęp do ustandaryzowanej bazy wiedzy.
#                   Wersja 0.2.1: Pełna integracja z wrapperem UI.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/dev_help.just
# VERSION:         0.2.1
# CREATED:         2026-07-20
# ============================================================================

# Wyświetla interaktywny przewodnik dla deweloperów frameworku Ambero
dev-help:
    @just _run-just "_dev-help-logic" "dev-help"

# ============================================================================
# SEKCJA: LOGIKA WEWNĘTRZNA (UKRYTA)
# ============================================================================

[private]
[no-cd]
_dev-help-logic:
    #!/usr/bin/env bash
    set -euo pipefail

    # --- KONFIGURACJA ŚRODOWISKA ---
    HELP_DIR="{{AMBERO_DIR}}/am_just/dev_help"

    # [EDU] Funkcja pomocnicza do odświeżania ekranu powitalnego.
    show_splash() {
        if test -f "$HELP_DIR/dev_help.txt"; then
        clear
        # [NOWE] Przywrócenie nagłówka po wyczyszczeniu ekranu
        just _ui-header "dev-help"
        cat "$HELP_DIR/dev_help.txt"
        fi
    }

    show_splash

    # --- GŁÓWNA PĘTLA INTERFEJSU ---
    while true; do
        echo -e "\n{{clr_amber}}{{style_bold}}🛠️  AMBERO DEVELOPER GUIDE - MENU GŁÓWNE{{style_reset}}"
        echo -e "----------------------------------------------------------------------------"
        echo -e "{{clr_info}}1){{style_reset}} ARCHITEKTURA I STRUKTURA KATALOGÓW"
        echo -e "{{clr_info}}2){{style_reset}} TWORZENIE WTYCZEK (PLUGINS)"
        echo -e "{{clr_info}}3){{style_reset}} JUST I INTEGRACJA SYSTEMOWA"
        echo -e "{{clr_info}}4){{style_reset}} INTERFEJS, VERBOSITY I i18n"
        echo -e "{{clr_red}}q){{style_reset}} Wyjście"

        echo -ne "\n{{clr_amber}}👉 Wybierz sekcję [1-4] lub q: {{style_reset}}"

        # Odczyt bezpośrednio z terminala (standard Ada-style dla interakcji)
        read -r choice < /dev/tty

        if [[ "$choice" == "q" ]]; then
            echo -e "{{clr_info}}👋 Powodzenia w rozbudowie Ambero!{{style_reset}}"
            break
        fi

        # Dynamiczne mapowanie plików sekcji
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            FILE="dev_help_s${choice}.txt"
            FULL_PATH="$HELP_DIR/$FILE"

            if test -f "$FULL_PATH"; then
                if test -s "$FULL_PATH"; then
                    clear
                    # [NOWE] Przywrócenie nagłówka przed wyświetleniem sekcji
                    just _ui-header "dev-help"
                    # Nagłówek sekcji pobrany z pierwszej linii pliku (format: # Tytuł)
                    SECTION_TITLE=$(head -n 1 "$FULL_PATH" | sed 's/^# //')

                    echo -e "{{clr_b_blue}}📘 SEKCJA $choice: $SECTION_TITLE{{style_reset}}"
                    echo -e "{{clr_blue}}----------------------------------------------------------------------------{{style_reset}}\n"

                    cat "$FULL_PATH"

                    echo -e "\n{{clr_blue}}----------------------------------------------------------------------------{{style_reset}}"
                    echo -ne "{{clr_warn}}Naciśnij ENTER, aby wrócić do menu...{{style_reset}}"
                    read -r _ < /dev/tty
                    show_splash
                else
                    echo -e "{{clr_warn}}⚠️  Plik sekcji $choice istnieje, ale jest pusty.{{style_reset}}"
                fi
            else
                echo -e "{{clr_error}}❌ Nie znaleziono pliku dla sekcji $choice.{{style_reset}}"
            fi
        else
            echo -e "{{clr_error}}❌ Nieprawidłowy wybór: $choice. Użyj cyfr 1-4 lub q.{{style_reset}}"
        fi
    done
