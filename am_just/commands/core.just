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
# VERSION:         0.3.5
# CREATED:         2026-07-21
# ============================================================================

# Wrapper dla wtyczek Amber (.ab)
@_run-amber plugin_path v="" mod="": _check_config
    @set -uo pipefail; \
    V_MODE="{{v}}"; \
    [[ -z "$V_MODE" ]] && V_MODE="{{verbosity}}"; \
    V_WEIGHT=$(just _get-verbosity-weight "$V_MODE"); \
    export AMBERO_VERBOSITY="$V_MODE"; \
    export AMBERO_VERBOSITY_WEIGHT="$V_WEIGHT"; \
    MODS="{{mod}}"; [[ -z "$MODS" ]] && MODS="{{modifiers}}"; \
    export AMBERO_MODIFIERS="$MODS"; \
    eval "$(just _init-session)"; \
    eval "$(just _timer-start)"; \
    just _ui-header "$CMD_NAME" "$V_MODE"; \
    PLUGIN_DIR=$(dirname "{{plugin_path}}"); \
    CORE_LINK="{{AMBERO_DIR}}/$PLUGIN_DIR/am_core"; \
    trap 'rm -f "$CORE_LINK"' EXIT INT TERM; \
    ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"; \
    EXIT_CODE=0; \
    amber run "{{AMBERO_DIR}}/{{plugin_path}}" || EXIT_CODE=$?; \
    if [ "$V_WEIGHT" -ge 3 ]; then just --allow-missing "{{plugin_path}}-edu" 2>/dev/null || true; fi; \
    DURATION=$(just _timer-stop); \
    just _ui-footer "$EXIT_CODE" "$DURATION" "$V_MODE"; \
    if [ "$V_WEIGHT" -ge 4 ]; then just --allow-missing "{{plugin_path}}-dev" 2>/dev/null || true; fi; \
    just _log-peek; \
    exit $EXIT_CODE

# Wrapper dla natywnych zadań Just
@_run-just internal_recipe display_name v="" mod="": _check_config
    @set -uo pipefail; \
    V_MODE="{{v}}"; \
    [[ -z "$V_MODE" ]] && V_MODE="{{verbosity}}"; \
    V_WEIGHT=$(just _get-verbosity-weight "$V_MODE"); \
    export AMBERO_VERBOSITY="$V_MODE"; \
    export AMBERO_VERBOSITY_WEIGHT="$V_WEIGHT"; \
    MODS="{{mod}}"; [[ -z "$MODS" ]] && MODS="{{modifiers}}"; \
    export AMBERO_MODIFIERS="$MODS"; \
    eval "$(just _init-session)"; \
    eval "$(just _timer-start)"; \
    just _ui-header "{{display_name}}" "$V_MODE"; \
    EXIT_CODE=0; \
    just {{internal_recipe}} || EXIT_CODE=$?; \
    if [ "$V_WEIGHT" -ge 3 ]; then just --allow-missing "{{internal_recipe}}-edu" 2>/dev/null || true; fi; \
    DURATION=$(just _timer-stop); \
    just _ui-footer "$EXIT_CODE" "$DURATION" "$V_MODE"; \
    if [ "$V_WEIGHT" -ge 4 ]; then just --allow-missing "{{internal_recipe}}-dev" 2>/dev/null || true; fi; \
    exit $EXIT_CODE
