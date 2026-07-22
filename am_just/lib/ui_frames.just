# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Silnik graficzny interfejsu (Nagłówki i Stopki).
#                   Implementuje styl "otwartych ramek" dla maksymalnej
#                   kompatybilności z różnymi szerokościami terminala.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/ui_frames.just
# VERSION:         0.3.0
# CREATED:         2026-07-21
# ============================================================================


# --- KOMUNIKATY LOKALNE (ETIKIETY UI) ---
msg_ui_cmd     := "POLECENIE:"
msg_ui_time    := "⏳ CZAS:"
msg_ui_status  := "STATUS:"
msg_ui_success := "SUKCES (0)"
msg_ui_error   := "BŁĄD"

# ============================================================================
# SEKCJA: RENDEROWANIE RAMEK
# ============================================================================

# Wyświetla nagłówek zadania (widoczny w trybach: prod, edu, dev)
@_ui-header command_name:
    @if [[ "{{verbosity}}" =~ ^(prod|p|edu|e|dev|d)$ ]]; then \
        echo -n -e "{{clr_amber}}┌──{{style_reset}} {{style_bold}}{{AMBERO_NAME}} v{{AMBERO_VERSION}}{{style_reset}} "; \
        echo -e "{{style_dim}}[ ID: $AMBERO_SESSION_ID ]{{style_reset}}"; \
        echo -e "{{clr_amber}}│{{style_reset}} {{clr_info}}{{msg_ui_cmd}}{{style_reset}} {{command_name}}"; \
        echo -e "{{clr_amber}}└──────────────────────────────────────────────────────────{{style_reset}}"; \
    fi

# Wyświetla stopkę z czasem i statusem
@_ui-footer status duration:
    @SHOW_FOOTER=0; \
    if [[ "{{verbosity}}" =~ ^(prod|p|edu|e|dev|d)$ ]]; then SHOW_FOOTER=1; fi; \
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
