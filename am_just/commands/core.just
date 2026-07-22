# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Główny silnik wykonawczy (Wrappery Middleware).
#                   Zapewnia spójne UI, logowanie i pomiar czasu dla
#                   wszystkich typów zadań we frameworku.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/core.just
# VERSION:         0.3.1
# CREATED:         2026-07-21
# ============================================================================


# Wrapper dla wtyczek Amber (.ab)
@_run-amber plugin_path v="" mod="": _check_config
    @set -uo pipefail; \
    eval "$(just _select-verbosity)"; \
    V_MODE="{{v}}"; \
    [[ -z "$V_MODE" ]] && V_MODE="{{verbosity}}"; \
    [[ -n "${AMBERO_SESSION_V:-}" ]] && V_MODE="$AMBERO_SESSION_V"; \
    V_WEIGHT=$(just _get-verbosity-weight "$V_MODE"); \
    export AMBERO_VERBOSITY="$V_MODE"; \
    export AMBERO_VERBOSITY_WEIGHT="$V_WEIGHT"; \
    export AMBERO_MODIFIERS="{{mod}}"; \
    eval "$(just _init-session)"; \
    eval "$(just _timer-start)"; \
    CMD_NAME=$(basename "{{plugin_path}}" .ab | tr "_" "-"); \
    just _ui-header "$CMD_NAME" "$V_MODE"; \
    PLUGIN_DIR=$(dirname "{{plugin_path}}"); \
    CORE_LINK="{{AMBERO_DIR}}/$PLUGIN_DIR/am_core"; \
    trap 'rm -f "$CORE_LINK"' EXIT INT TERM; \
    ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"; \
    EXIT_CODE=0; \
    amber run "{{AMBERO_DIR}}/{{plugin_path}}" || EXIT_CODE=$?; \
    DURATION=$(just _timer-stop); \
    just _ui-footer "$EXIT_CODE" "$DURATION" "$V_MODE"; \
    just _log-peek; \
    exit $EXIT_CODE

# Wrapper dla natywnych zadań Just
@_run-just internal_recipe display_name v="" mod="": _check_config
    @set -uo pipefail; \
    eval "$(just _select-verbosity)"; \
    V_MODE="{{v}}"; \
    [[ -z "$V_MODE" ]] && V_MODE="{{verbosity}}"; \
    [[ -n "${AMBERO_SESSION_V:-}" ]] && V_MODE="$AMBERO_SESSION_V"; \
    V_WEIGHT=$(just _get-verbosity-weight "$V_MODE"); \
    export AMBERO_VERBOSITY="$V_MODE"; \
    export AMBERO_VERBOSITY_WEIGHT="$V_WEIGHT"; \
    export AMBERO_MODIFIERS="{{mod}}"; \
    eval "$(just _init-session)"; \
    eval "$(just _timer-start)"; \
    just _ui-header "{{display_name}}" "$V_MODE"; \
    EXIT_CODE=0; \
    just {{internal_recipe}} || EXIT_CODE=$?; \
    DURATION=$(just _timer-stop); \
    just _ui-footer "$EXIT_CODE" "$DURATION" "$V_MODE"; \
    just _log-peek; \
    exit $EXIT_CODE
