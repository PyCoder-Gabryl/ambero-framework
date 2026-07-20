# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Narzędzie podglądu ostatniego logu (Peek).
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/logger_peek.just
# VERSION:         0.1.0
# CREATED:         2026-07-20
# ============================================================================
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# Wyświetla ostatnią linię z logu JSONL (jeśli aktywny modyfikator 'log')
@_log-peek:
    #!/usr/bin/env bash
    # Sprawdzamy czy w zmiennej MODIFIERS znajduje się flaga 'l' lub 'log'
    if [[ "${AMBERO_MODIFIERS:-}" =~ (^|,)(log|l)(,|$) ]]; then
        LOG_FILE="{{AMBERO_DIR}}/logs/json/ambero.jsonl"
        if test -f "$LOG_FILE"; then
            echo -e "\n{{clr_info}}📋 OSTATNI LOG (JSONL):{{style_reset}}"
            tail -n 1 "$LOG_FILE"
        fi
    fi
