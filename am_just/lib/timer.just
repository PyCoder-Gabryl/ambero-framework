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
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# [EDU] Pobiera czas w ms używając Pythona (bezpieczne dla macOS i Linux).
@_timer-start:
    #!/usr/bin/env bash
    MS=$(python3 -c 'import time; print(int(time.time() * 1000))')
    echo "export AMBERO_START_TIME=$MS"

# [EDU] Oblicza różnicę czasu i formatuje do sekund.
@_timer-stop:
    #!/usr/bin/env bash
    END_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
    # Zabezpieczenie przed pustym startem
    START=${AMBERO_START_TIME:-$END_TIME}
    DIFF=$((END_TIME - START))
    echo "$DIFF" | awk '{printf "%.2f", $1/1000}'
