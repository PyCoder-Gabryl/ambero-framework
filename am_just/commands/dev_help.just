# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Interaktywny przewodnik dewelopera Ambero.
#                   Zapewnia dostęp do ustandaryzowanej bazy wiedzy
#                   dotyczącej architektury, wtyczek i silnika Just.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/dev_help.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================

# Wyświetla interaktywny przewodnik dla deweloperów frameworku Ambero
dev-help:
    #!/usr/bin/env bash
    # [EDU] set -euo pipefail:
    # -e: kończy skrypt przy błędzie dowolnej komendy.
    # -u: traktuje niezdefiniowane zmienne jako błąd.
    # -o pipefail: wyłapuje błędy ukryte wewnątrz potoków (pipes).
    set -euo pipefail

    # ============================================================================
    # SEKCJA: KONFIGURACJA ŚCIEŻEK I ŚRODOWISKA
    # ============================================================================
    HELP_DIR="{{AMBERO_DIR}}/am_just/dev_help"

    # --- FUNKCJA: POWITANIE ---
    # Wyświetla główny ekran powitalny (Splash Screen)
    show_splash() {
        if test -f "$HELP_DIR/dev_help.txt"; then
            clear
            cat "$HELP_DIR/dev_help.txt"
        fi
    }

    # ============================================================================
    # SEKCJA: GŁÓWNA PĘTLA INTERFEJSU (UI LOOP)
    # ============================================================================
    show_splash

    while true; do
        echo -e "\n{{clr_amber}}{{style_bold}}🛠️  AMBERO DEVELOPER GUIDE - MENU GŁÓWNE{{style_reset}}"
        echo -e "----------------------------------------------------------------------------"
        echo -e "{{clr_info}}1){{style_reset}} ARCHITEKTURA I STRUKTURA KATALOGÓW"
        echo -e "{{clr_info}}2){{style_reset}} TWORZENIE WTYCZEK (PLUGINS)"
        echo -e "{{clr_info}}3){{style_reset}} JUST I INTEGRACJA SYSTEMOWA"
        echo -e "{{clr_info}}4){{style_reset}} INTERFEJS, VERBOSITY I i18n"
        echo -e "{{clr_red}}q){{style_reset}} Wyjście"

        echo -ne "\n{{clr_amber}}👉 Wybierz sekcję [1-4] lub q: {{style_reset}}"

        # [EDU] Przekierowanie < /dev/tty jest kluczowe. Pozwala na odczyt wejścia
        # bezpośrednio z klawiatury użytkownika, nawet jeśli Just jest częścią
        # większego potoku poleceń lub skryptu.
        read -r choice < /dev/tty

        # --- OBSŁUGA WYJŚCIA ---
        if [[ "$choice" == "q" ]]; then
            echo -e "{{clr_info}}👋 Powodzenia w rozbudowie Ambero!{{style_reset}}"
            break
        fi

        # --- LOGIKA WYBORU SEKCI (DYNAMICZNA) ---
        # Sprawdzamy czy wybór jest liczbą i czy odpowiadający plik istnieje
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            FILE="dev_help_s${choice}.txt"
            FULL_PATH="$HELP_DIR/$FILE"

            if test -f "$FULL_PATH"; then
                if test -s "$FULL_PATH"; then
                    clear
                    # Pobieramy tytuł z pierwszej linii pliku (format: # Tytuł)
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
