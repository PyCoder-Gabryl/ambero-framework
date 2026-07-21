# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Centralny rejestr kolorów i stylów ANSI dla Just.
#                   Zapewnia spójność wizualną komunikatów generowanych
#                   bezpośrednio przez receptury Justfile.
# ----------------------------------------------------------------------------
# PATH:            am_just/colors.just
# VERSION:         0.2.4
# CREATED:         2026-07-20
# ============================================================================


# Wrapper dla wtyczek Amber (.ab)
@_run-amber plugin_path: _check_config
    #!/usr/bin/env bash
    set -uo pipefail
    eval "$(just _init-session)"
    eval "$(just _timer-start)"
    CMD_NAME=$(basename "{{plugin_path}}" .ab | tr "_" "-")
    just _ui-header "$CMD_NAME"

    PLUGIN_DIR=$(dirname "{{plugin_path}}")
    CORE_LINK="{{AMBERO_DIR}}/$PLUGIN_DIR/am_core"
    trap 'rm -f "$CORE_LINK"' EXIT INT TERM
    ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"

    EXIT_CODE=0
    amber run "{{AMBERO_DIR}}/{{plugin_path}}" || EXIT_CODE=$?

    DURATION=$(just _timer-stop)
    just _ui-footer "$EXIT_CODE" "$DURATION"
    just _log-peek
    exit $EXIT_CODE

# Wrapper dla natywnych zadań Just
@_run-just internal_recipe display_name: _check_config
    #!/usr/bin/env bash
    set -uo pipefail
    eval "$(just _init-session)"
    eval "$(just _timer-start)"
    just _ui-header "{{display_name}}"

    EXIT_CODE=0
    just {{internal_recipe}} || EXIT_CODE=$?

    DURATION=$(just _timer-stop)
    just _ui-footer "$EXIT_CODE" "$DURATION"
    just _log-peek
    exit $EXIT_CODE
