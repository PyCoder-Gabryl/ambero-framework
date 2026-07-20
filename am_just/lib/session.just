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

# [EDU] Generuje 5-znakowy ID sesji na podstawie nanosekund.
#       Używamy 'export', aby ID było dostępne dla wszystkich skryptów Amber.
@_init-session:
    #!/usr/bin/env bash
    # Wykorzystujemy sumę kontrolną z czasu, aby uzyskać znaki alfanumeryczne
    SESSION_ID=$(date +%s%N | md5sum | head -c 5 | tr '[:lower:]' '[:upper:]')
    echo "export AMBERO_SESSION_ID=$SESSION_ID"
