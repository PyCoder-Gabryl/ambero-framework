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
# VERSION:         0.2.0
# CREATED:         2026-07-21
# ============================================================================
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================


# Wyświetla nagłówek zadania (widoczny w trybach: prod, edu, dev)
@_ui-header command_name:
    #!/usr/bin/env bash
    if [[ "{{verbosity}}" =~ ^(prod|p|edu|e|dev|d)$ ]]; then
        echo -e "{{clr_amber}}┌──{{style_reset}} {{style_bold}}{{AMBERO_NAME}} v{{AMBERO_VERSION}}{{style_reset}} \
{{style_dim}}[ ID: ${AMBERO_SESSION_ID:-NONE} ]{{style_reset}}"
        echo -e "{{clr_amber}}│{{style_reset}} {{clr_info}}POLECENIE:{{style_reset}} {{command_name}}"
        echo -e "{{clr_amber}}└──────────────────────────────────────────────────────────{{style_reset}}"
    fi

# Wyświetla stopkę z czasem i statusem (widoczna w trybach: prod, edu, dev)
@_ui-footer status duration:
    #!/usr/bin/env bash
    if [[ "{{verbosity}}" =~ ^(prod|p|edu|e|dev|d)$ ]]; then
        FRAME_CLR="{{clr_amber}}"
        STATUS_TXT="{{clr_success}}SUKCES (0){{style_reset}}"
        if [ "{{status}}" != "0" ]; then
            FRAME_CLR="{{clr_red}}"
            STATUS_TXT="{{clr_error}}BŁĄD ({{status}}){{style_reset}}"
        fi
        echo -e "${FRAME_CLR}┌──────────────────────────────────────────────────────────{{style_reset}}"
        echo -e "${FRAME_CLR}│{{style_reset}} {{clr_info}}⏳ CZAS:{{style_reset}} {{duration}}s \
{{style_dim}}|{{style_reset}} {{clr_info}}STATUS:{{style_reset}} ${STATUS_TXT}"
        echo -e "${FRAME_CLR}└──────────────────────────────────────────────────────────{{style_reset}}"
    fi
