# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Narzędzie podglądu ostatniego logu (Peek).
#                   Wyświetla ostatni wpis JSONL dla celów diagnostycznych.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/logger_peek.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================


# --- KOMUNIKATY LOKALNE ---
msg_log_peek := "📋 OSTATNI LOG (JSONL):"

# ============================================================================
# SEKCJA: INSPEKCJA LOGÓW
# ============================================================================

# Wyświetla ostatnią linię z logu JSONL (jeśli aktywny modyfikator 'log')
@_log-peek:
    @if [[ "${AMBERO_MODIFIERS:-}" =~ (^|,)(log|l)(,|$) ]]; then \
        LOG_FILE="{{AMBERO_DIR}}/logs/json/ambero.jsonl"; \
        if test -f "$LOG_FILE"; then \
            echo -e "\n{{clr_info}}{{msg_log_peek}}{{style_reset}}"; \
            tail -n 1 "$LOG_FILE"; \
        fi; \
    fi
