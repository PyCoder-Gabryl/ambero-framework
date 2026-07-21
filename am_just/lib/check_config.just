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
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# Klauzula bezpieczeństwa: Weryfikuje obecność pliku konfiguracyjnego.
# Zapobiega błędom wykonania skryptów Amber przed inicjalizacją systemu.
@_check_config:
    #!/usr/bin/env bash
    # [ZMIANA] Usunięto zbędne backslashe - w recepturach shebang piszemy czysty kod Bash.
    if [ ! -f "{{CONFIG_FILE}}" ]; then
        echo -e "{{clr_error}}❌ Błąd krytyczny: Brak pliku konfiguracji {{CONFIG_FILE}}!{{style_reset}}"
        echo -e "{{clr_warn}}👉 Uruchom instalator (am_install/install.sh), aby wygenerować system.{{style_reset}}"
        exit 1
    fi
