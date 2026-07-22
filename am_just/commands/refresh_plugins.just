# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.5
# ----------------------------------------------------------------------------
# DESCRIPTION:      Zaawansowany skaner i rejestrator wtyczek (plugins).
#                   Przeszukuje katalog am_plugins, generuje zadania Just
#                   i zarządza symlinkami rdzenia dla izolacji wtyczek.
#                   Wersja 0.2.4: Integracja z wrapperem UI i fix błędu grep.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/refresh_plugins.just
# VERSION:         0.2.4
# CREATED:         2026-07-19
# ============================================================================

# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
refresh-plugins:
    @just _run-just "_refresh-plugins-logic" "refresh-plugins"

[private]
[no-cd]
_refresh-plugins-logic:
    #!/usr/bin/env bash
    set -euo pipefail

    # [NOWE] Gwarancja istnienia katalogu przed rozpoczęciem generowania
    mkdir -p "{{AMBERO_DIR}}/am_plugins"

    echo -e "{{clr_info}}🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero...{{style_reset}}"

    AMBERO_DIR="{{AMBERO_DIR}}"
    OUT_FILE="$AMBERO_DIR/am_plugins/plugins.just"
    TMP_REG=$(mktemp)

    OLD_TARGETS=$(grep -E "^[a-zA-Z0-9_-]+:" "$OUT_FILE" 2>/dev/null | cut -d: -f1 | tr "\n" " ") || true

    # --- GENEROWANIE NAGŁÓWKA REJESTRU ---
    printf "# ============================================================================\n" > "$TMP_REG"
    printf "# PROJECT:         AMBERO FRAMEWORK CLI\n" >> "$TMP_REG"
    printf "# GENERATED:       $(date "+%Y-%m-%d %H:%M:%S")\n" >> "$TMP_REG"
    printf "# DESCRIPTION:     Automatycznie wygenerowany rejestr wtyczek.\n" >> "$TMP_REG"
    printf "# ----------------------------------------------------------------------------\n" >> "$TMP_REG"
    printf "# !!! UWAGA: PLIK GENEROWANY AUTOMATYCZNIE - NIE EDYTUJ RĘCZNIE !!!\n" >> "$TMP_REG"
    printf "# !!! WARNING: AUTOMATICALLY GENERATED FILE - DO NOT EDIT MANUALLY !!!\n" >> "$TMP_REG"
    printf "# ============================================================================\n\n" >> "$TMP_REG"

    # ... (reszta logiki skanowania pozostaje bez zmian) ...

    mv "$TMP_REG" "$OUT_FILE"

    echo "------------------------------------------------------------"
    echo -e "📊 PODSUMOWANIE REJESTRACJI:"
    printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"
    printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"
    echo "------------------------------------------------------------"
    echo -e "{{clr_success}}✅ Gotowe! Rejestr: am_plugins/plugins.just{{style_reset}}"
