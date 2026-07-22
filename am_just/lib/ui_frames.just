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
# VERSION:         0.2.6
# CREATED:         2026-07-21
# ============================================================================


@_ui-header command_name:
    @if [[ "{{verbosity}}" =~ ^(prod|p|edu|e|dev|d)$ ]]; then \
        echo -e "{{clr_amber}}┌──{{style_reset}} {{style_bold}}{{AMBERO_NAME}} v{{AMBERO_VERSION}}{{style_reset}} {{style_dim}}[ ID: $AMBERO_SESSION_ID ]{{style_reset}}"; \
        echo -e "{{clr_amber}}│{{style_reset}} {{clr_info}}POLECENIE:{{style_reset}} {{command_name}}"; \
        echo -e "{{clr_amber}}└──────────────────────────────────────────────────────────{{style_reset}}"; \
    fi

@_ui-footer status duration:
    @SHOW_FOOTER=0; \
    if [[ "{{verbosity}}" =~ ^(prod|p|edu|e|dev|d)$ ]]; then SHOW_FOOTER=1; fi; \
    if [[ "${AMBERO_MODIFIERS:-}" =~ (^|,)(time|t)(,|$) ]]; then SHOW_FOOTER=1; fi; \
    if [ "$SHOW_FOOTER" -eq 1 ]; then \
        FRAME_CLR="{{clr_amber}}"; \
        STATUS_TXT="{{clr_success}}SUKCES (0){{style_reset}}"; \
        if [ "{{status}}" != "0" ]; then \
            FRAME_CLR="{{clr_red}}"; \
            STATUS_TXT="{{clr_error}}BŁĄD ({{status}}){{style_reset}}"; \
        fi; \
        echo -e "${FRAME_CLR}┌──────────────────────────────────────────────────────────{{style_reset}}"; \
        echo -e "${FRAME_CLR}│{{style_reset}} {{clr_info}}⏳ CZAS:{{style_reset}} {{duration}}s {{style_dim}}|{{style_reset}} {{clr_info}}STATUS:{{style_reset}} ${STATUS_TXT}"; \
        echo -e "${FRAME_CLR}└──────────────────────────────────────────────────────────{{style_reset}}"; \
    fi
