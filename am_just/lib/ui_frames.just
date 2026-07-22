# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Silnik graficzny interfejsu (Nagłówki i Stopki).
#                   Wersja 0.3.4: Dynamiczne etykiety trybów pracy (Verbosity).
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/ui_frames.just
# VERSION:         0.3.4
# CREATED:         2026-07-21
# ============================================================================


# --- SEKCJA: ETIKIETY KOMUNIKATÓW (i18n Ready) ---
msg_ui_cmd     := "POLECENIE:"
msg_ui_mode    := "TRYB:"
msg_ui_time    := "⏳ CZAS:"
msg_ui_status  := "STATUS:"
msg_ui_success := "SUKCES (0)"
msg_ui_error   := "BŁĄD"

# ============================================================================
# SEKCJA: RENDEROWANIE RAMEK UI
# ============================================================================

# Wyświetla nagłówek zadania (v pozwala na nadpisanie trybu globalnego)
@_ui-header command_name v="":
    @V_MODE="{{v}}"; \
    [[ -z "$V_MODE" ]] && V_MODE="{{verbosity}}"; \
    if [[ "$V_MODE" =~ ^(prod|p|edu|e|dev|d)$ ]]; then \
        MODE_INFO=""; \
        if [[ "$V_MODE" =~ ^(edu|e|dev|d)$ ]]; then \
            case "$V_MODE" in \
                "edu"|"e") MODE_LBL="{{clr_b_purple}}EDU{{style_reset}}" ;; \
                "dev"|"d") MODE_LBL="{{clr_b_yellow}}DEV{{style_reset}}" ;; \
            esac; \
            MODE_INFO=" [ {{msg_ui_mode}} $MODE_LBL ]"; \
        fi; \
        echo -n -e "{{clr_amber}}┌──{{style_reset}} {{style_bold}}{{AMBERO_NAME}} v{{AMBERO_VERSION}}{{style_reset}} "; \
        echo -e "{{style_dim}}[ ID: $AMBERO_SESSION_ID ]{{style_reset}}"; \
        echo -e "{{clr_amber}}│{{style_reset}} {{clr_info}}{{msg_ui_cmd}}{{style_reset}} {{command_name}}$MODE_INFO"; \
        echo -e "{{clr_amber}}└──────────────────────────────────────────────────────────{{style_reset}}"; \
    fi

# Wyświetla stopkę z czasem i statusem
@_ui-footer status duration v="":
    @V_MODE="{{v}}"; \
    [[ -z "$V_MODE" ]] && V_MODE="{{verbosity}}"; \
    SHOW_FOOTER=0; \
    if [[ "$V_MODE" =~ ^(prod|p|edu|e|dev|d)$ ]]; then SHOW_FOOTER=1; fi; \
    if [[ "${AMBERO_MODIFIERS:-}" =~ (^|,)(time|t)(,|$) ]]; then SHOW_FOOTER=1; fi; \
    if [ "$SHOW_FOOTER" -eq 1 ]; then \
        FRAME_CLR="{{clr_amber}}"; \
        STATUS_TXT="{{clr_success}}{{msg_ui_success}}{{style_reset}}"; \
        if [ "{{status}}" != "0" ]; then \
            FRAME_CLR="{{clr_red}}"; \
            STATUS_TXT="{{clr_error}}{{msg_ui_error}} ({{status}}){{style_reset}}"; \
        fi; \
        echo -e "${FRAME_CLR}┌──────────────────────────────────────────────────────────{{style_reset}}"; \
        echo -n -e "${FRAME_CLR}│{{style_reset}} {{clr_info}}{{msg_ui_time}}{{style_reset}} {{duration}}s "; \
        echo -e "{{style_dim}}|{{style_reset}} {{clr_info}}{{msg_ui_status}}{{style_reset}} ${STATUS_TXT}"; \
        echo -e "${FRAME_CLR}└──────────────────────────────────────────────────────────{{style_reset}}"; \
    fi
