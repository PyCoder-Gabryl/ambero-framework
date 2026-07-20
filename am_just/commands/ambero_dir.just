# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator mapy ścieżek frameworku. Odpowiada za
#                   tworzenie i aktualizację pliku ambero_paths.toml.
#                   Wersja 0.2.4 przywraca pełne raportowanie zmian.
# ----------------------------------------------------------------------------
# PATH:            am_just/ambero_dir.just
# VERSION:         0.2.4
# CREATED:         2026-07-20
# ============================================================================


# Generuje lub aktualizuje plik konfiguracyjny ze ścieżkami
map-paths:
    @just _run-just "_map-paths-logic" "map-paths"

# Drukuje zmapowane sekcje i ścieżki w czytelny sposób
dir-view:
    @just _run-just "_dir-view-logic" "dir-view"

# --- LOGIKA WEWNĘTRZNA (UKRYTA) ---

[private]
[no-cd]
_map-paths-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    # ... (tutaj wklej całą logikę Bash z poprzedniej wersji map-paths) ...
    # Pamiętaj o zmianie 'just dir-view' na 'just _dir-view-logic' na końcu!

[private]
[no-cd]
_dir-view-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    # ... (tutaj wklej całą logikę Bash z poprzedniej wersji dir-view) ...
