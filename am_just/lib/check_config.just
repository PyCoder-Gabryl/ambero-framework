# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł weryfikacji spójności konfiguracji (Sanity Check).
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/check_config.just
# VERSION:         0.1.1
# CREATED:         2026-07-20
# ============================================================================


# Klauzula bezpieczeństwa: Weryfikuje obecność pliku konfiguracyjnego.
@_check_config:
    @if [ ! -f "{{CONFIG_FILE}}" ]; then \
        echo -e "{{clr_warn}}⚠️  Informacja: Brak pliku konfiguracji. Ambero użyje wartości domyślnych.{{style_reset}}"; \
    fi
