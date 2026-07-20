# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł archiwizacji projektu. Pakuje strukturę frameworku
#                   do formatu ZIP w celu udostępniania kodu (np. dla AI).
#                   Pomija historię Git, logi oraz lokalną konfigurację.
# ----------------------------------------------------------------------------
# PATH:            am_just/backup.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================

# ============================================================================
# SEKCJA: GŁÓWNE ZADANIA ARCHIWIZACJI
# ============================================================================

# Tworzy kopię zapasową projektu w formacie .zip (do wysłania mentorowi AI)
[no-cd]
backup-project:
    #!/usr/bin/env bash
    set -euo pipefail

    # --- KONFIGURACJA LOKALNA ---
    B_DIR="{{BACKUP_DIR}}"
    A_DIR="{{AMBERO_DIR}}"
    TS=$(date +"%Y%m%d_%H%M%S")
    B_NAME="ambero_v{{AMBERO_VERSION}}_${TS}.zip"

    echo -e "{{clr_info}}📦 Przygotowywanie archiwum projektu...{{style_reset}}"
    mkdir -p "$B_DIR"

    # --- PROCES PAKOWANIA ---
    # [EDU] Flaga -x pozwala wykluczyć wzorce plików. Używamy jej, aby archiwum
    # było lekkie i nie zawierało prywatnych danych IDE ani ciężkiej historii Git.
    # Wykluczamy też config.toml, aby nie przesyłać lokalnych ścieżek.
    cd "$A_DIR" && zip -r "$B_DIR/$B_NAME" . \
        -x "backups/*" \
        -x ".git/*" \
        -x ".idea/*" \
        -x "logs/*" \
        -x "*.iml" \
        -x "am_config/config.toml" \
        > /dev/null

    # --- RAPORTOWANIE ---
    echo -e "{{clr_success}}✅ Kopia zapasowa została utworzona pomyślnie!{{style_reset}}"
    echo -e "{{clr_amber}}📂 Lokalizacja:{{style_reset}} $B_DIR/$B_NAME"

    # Wyświetlenie rozmiaru archiwum dla pewności
    ls -lh "$B_DIR/$B_NAME" | awk '{printf "📊 Rozmiar pliku: %s\n", $5}'

# ============================================================================
# KOMENTARZ EDUKACYJNY (JUST & BASH)
# ============================================================================
# [EDU] 1. Atrybut [no-cd] gwarantuje, że Just nie zmieni katalogu przed
#          uruchomieniem skryptu, co pozwala nam na ręczne sterowanie przez 'cd'.
# [EDU] 2. Użycie 'set -euo pipefail' wewnątrz shebangu to standard Ada-style.
#          Skrypt przerwie pracę, jeśli np. brakuje narzędzia 'zip'.
# [EDU] 3. Zmienne Justa {{...}} są wstrzykiwane do skryptu przed jego startem.
