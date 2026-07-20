# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Rdzeń wykonawczy Just dla frameworku Ambero.
#                   Implementuje bezpieczny wrapper 'run-amber', który
#                   zarządza izolacją wtyczek poprzez symlinki am_core
#                   oraz gwarantuje czystość środowiska dzięki mechanizmowi trap.
# ----------------------------------------------------------------------------
# PATH:            am_just/core.just
# VERSION:         0.1.3
# CREATED:         2026-07-20
# ============================================================================


# [EDU] @_run-amber to teraz kontener typu Middleware.
# 1. Inicjalizuje sesję (ID).
# 2. Wyświetla profesjonalny nagłówek.
# 3. Zarządza izolacją i sprzątaniem (Trap).
@_run-amber plugin_path: _check_config
    @bash -c ' \
        # --- KROK 1: INICJALIZACJA METADANYCH --- \
        eval $(just _init-session); \ # [NOWA]
        CMD_NAME=$(basename "{{plugin_path}}" .ab | tr "_" "-"); \ # [NOWA]
        \
        # --- KROK 2: WARSTWA PREZENTACJI (NAGŁÓWEK) --- \
        just _ui-header "$CMD_NAME"; \ # [NOWA]
        \
        # --- KROK 3: IZOLACJA I URUCHOMIENIE --- \
        PLUGIN_DIR=$(dirname "{{plugin_path}}"); \
        FULL_PLUGIN_DIR="{{AMBERO_DIR}}/$PLUGIN_DIR"; \
        CORE_LINK="$FULL_PLUGIN_DIR/am_core"; \
        trap "rm -f $CORE_LINK" EXIT INT TERM; \
        ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"; \
        amber run "{{AMBERO_DIR}}/{{plugin_path}}"'
