# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Silnik pomiaru czasu wykonania (Timer).
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/timer.just
# VERSION:         0.1.0
# CREATED:         2026-07-20
# ============================================================================


@_init-session: # [ZMIANA] Dodano @
    #!/usr/bin/env bash
    RAW_ID=$(echo "$$ $(date +%s)" | cksum | cut -c1-5 | tr '[:lower:]' '[:upper:]')
    SESSION_ID=${RAW_ID:-00000}
    echo "export AMBERO_SESSION_ID=$SESSION_ID"
