# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł archiwizacji projektu do komunikacji z ekspertem.
#                   Tworzy paczkę ZIP zawierającą pełny kod i konfigurację,
#                   czyszcząc wcześniej stare archiwa i pomijając śmieci.
# ----------------------------------------------------------------------------
# PATH:            am_just/backup.just
# VERSION:         0.2.1
# CREATED:         2026-07-20
# ============================================================================

# ============================================================================
# SEKCJA: ZADANIA ARCHIWIZACJI (TRANSFER DO AI)
# ============================================================================

# Pakuje projekt do ZIP (włącza config.toml, usuwa stare kopie, pomija śmieci)
backup-project:
    @just _run-just "_backup-project-logic" "backup-project" # [ZMIANA] Podpięcie pod wrapper

[private]
[no-cd]
_backup-project-logic: # [ZMIANA] Przeniesienie logiki do zadania prywatnego
    #!/usr/bin/env bash
    set -euo pipefail

    B_DIR="{{BACKUP_DIR}}"
    A_DIR="{{AMBERO_DIR}}"
    PROJ_SLUG="ambero"
    B_NAME="${PROJ_SLUG}_v{{AMBERO_VERSION}}.zip"

    echo -e "{{clr_info}}🧹 Czyszczenie starych kopii zapasowych...{{style_reset}}"
    mkdir -p "$B_DIR"
    rm -f "$B_DIR"/*.zip

    echo -e "{{clr_info}}📦 Pakowanie projektu dla mentora AI...{{style_reset}}"

    cd "$A_DIR" && zip -r "$B_DIR/$B_NAME" . \
        -x ".git/*" -x ".idea/*" -x ".vscode/*" -x "*.iml" \
        -x "logs/*" -x "backups/*" -x ".DS_Store" -x "__MACOSX" \
        -x "Thumbs.db" -x "desktop.ini" -x "*~" -x "*.swp" \
        -x ".fuse_hidden*" \
        > /dev/null

    echo -e "{{clr_success}}✅ Archiwum gotowe do wysłania!{{style_reset}}"
    echo -e "{{clr_amber}}📍 Ścieżka:{{style_reset}} $B_DIR/$B_NAME"

    SIZE=$(ls -lh "$B_DIR/$B_NAME" | awk '{print $5}')
    echo -e "{{clr_info}}📊 Rozmiar paczki: $SIZE{{style_reset}}"
