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
# VERSION:         0.1.2
# CREATED:         2026-07-20
# ============================================================================


# [EDU] run-amber to serce integracji Just + Amber.
# 1. Oblicza relatywną ścieżkę do wtyczki.
# 2. Ustawia pułapkę (trap), która usunie symlink am_core nawet przy Ctrl+C.
# 3. Tworzy symlink, aby wtyczka mogła używać 'import ... from "am_core/..."'.
# 4. Uruchamia skrypt Amber w bezpiecznym kontekście.
@_run-amber plugin_path: _check_config
    @bash -c ' \
        PLUGIN_DIR=$(dirname "{{plugin_path}}"); \
        FULL_PLUGIN_DIR="{{AMBERO_DIR}}/$PLUGIN_DIR"; \
        CORE_LINK="$FULL_PLUGIN_DIR/am_core"; \
        trap "rm -f $CORE_LINK" EXIT INT TERM; \
        ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"; \
        amber run "{{AMBERO_DIR}}/{{plugin_path}}"'
