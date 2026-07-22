# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator unikalnych identyfikatorów sesji (UUID-lite).
#                   Zapewnia identyfikowalność wywołań w logach.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/session.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================


# ============================================================================
# SEKCJA: GENERATOR SESJI
# ============================================================================

# Inicjalizuje unikalny identyfikator dla bieżącego procesu
@_init-session:
    @RAW_ID=$(echo "$$ $(date +%s)" | cksum | cut -c1-5 | tr '[:lower:]' '[:upper:]'); \
    SESSION_ID=${RAW_ID:-00000}; \
    echo "export AMBERO_SESSION_ID=$SESSION_ID"

# ============================================================================
# KOMENTARZ EDUKACYJNY (SYSTEM)
# ============================================================================
# [EDU] Użycie 'cksum' zamiast 'md5sum' zapewnia kompatybilność między
#       macOS a Linuxem bez instalowania dodatkowych pakietów.
