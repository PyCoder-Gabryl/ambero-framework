# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator unikalnych identyfikatorów sesji (UUID-lite).
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/session.just
# VERSION:         0.1.0
# CREATED:         2026-07-20
# ============================================================================
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# [EDU] Generuje 5-znakowy ID sesji.
#       Używamy domyślnej wartości '00000' w razie błędu cksum.
@_init-session:
    #!/usr/bin/env bash
    RAW_ID=$(echo "$$ $(date +%s)" | cksum | cut -c1-5 | tr '[:lower:]' '[:upper:]')
    SESSION_ID=${RAW_ID:-00000}
    echo "export AMBERO_SESSION_ID=$SESSION_ID"
