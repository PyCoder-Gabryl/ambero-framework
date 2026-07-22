# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Zarządca poziomów komunikacji (Verbosity Manager).
#                   Obsługuje logikę wag oraz interaktywny wybór trybu.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/verbosity.just
# VERSION:         0.1.1
# CREATED:         2026-07-22
# ============================================================================
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# ============================================================================
# SEKCJA: LOGIKA WAG I KONWERSJI
# ============================================================================

# Zamienia tekstową nazwę trybu na wagę numeryczną (0-4)
@_get-verbosity-weight mode:
    @case "{{mode}}" in \
        "quiet"|"q")   echo 0 ;; \
        "minimal"|"min") echo 1 ;; \
        "prod"|"p")    echo 2 ;; \
        "edu"|"e")     echo 3 ;; \
        "dev"|"d")     echo 4 ;; \
        *)             echo 2 ;; \
    esac

# ============================================================================
# SEKCJA: INTERAKTYWNY SELEKTOR (TYLKO DLA DEV)
# ============================================================================

# Pozwala na zmianę trybu "w locie" podczas pracy nad projektem
@_select-verbosity:
    @#!/usr/bin/env bash \
    if [ "{{IS_DEV_ENV}}" == "true" ]; then \
        if [ -z "${AMBERO_SESSION_V:-}" ]; then \
            echo -e "\n{{clr_amber}}{{style_bold}}┌── 🛠️  AMBERO INTERACTIVE SESSION SETUP{{style_reset}}"; \
            echo -e "{{clr_amber}}│{{style_reset}} {{clr_info}}Wykryto środowisko projektowe (DEV).{{style_reset}}"; \
            echo -e "{{clr_amber}}│{{style_reset}} Wybierz głośność [q/min/prod/edu/dev] (Enter=dev): "; \
            echo -n -e "{{clr_amber}}└──{{style_reset}} 👉 " > /dev/tty; \
            read -r user_v < /dev/tty; \
            FINAL_V=${user_v:-dev}; \
            echo "export AMBERO_SESSION_V=$FINAL_V"; \
        else \
            echo "export AMBERO_SESSION_V=$AMBERO_SESSION_V"; \
        fi; \
    fi

# ============================================================================
# KOMENTARZ EDUKACYJNY (JUST & ARCHITEKTURA)
# ============================================================================
# [EDU] 1. Używamy wag numerycznych, aby w skryptach Amber i Bash stosować
#          proste porównania matematyczne (np. if weight >= 2).
# [EDU] 2. Zmienna AMBERO_SESSION_V zapobiega wielokrotnemu pytaniu o tryb
#          w tej samej sesji terminala (User Experience).
# [EDU] 3. 'prod' jest nazwą oficjalną dla standardowego poziomu wyjścia.
