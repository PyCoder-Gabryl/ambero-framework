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
# VERSION:         0.2.1
# CREATED:         2026-07-21
# ============================================================================


# Wrapper dla wtyczek Amber (.ab)
@_run-amber plugin_path: _check_config
    #!/usr/bin/env bash
    set -uo pipefail

    # 1. Inicjalizacja sesji i czasu
    eval "$(just _init-session)"
    eval "$(just _timer-start)"

    # 2. Nazwa komendy dla nagłówka
    CMD_NAME=$(basename "{{plugin_path}}" .ab | tr "_" "-")
    just _ui-header "$CMD_NAME"

    # 3. Izolacja (Sandbox)
    # [EDU] Obliczamy katalog wtyczki, aby stworzyć symlink am_core dokładnie tam, gdzie jest potrzebny.
    PLUGIN_DIR=$(dirname "{{plugin_path}}")
    CORE_LINK="{{AMBERO_DIR}}/$PLUGIN_DIR/am_core"

    # Trap gwarantuje czystość środowiska
    trap 'rm -f "$CORE_LINK"' EXIT INT TERM
    ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"

    # 4. Wykonanie Ambera
    EXIT_CODE=0
    amber run "{{AMBERO_DIR}}/{{plugin_path}}" || EXIT_CODE=$?

    # 5. Stopka i logi
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
