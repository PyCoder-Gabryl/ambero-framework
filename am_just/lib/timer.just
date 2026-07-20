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

# [EDU] Pobiera aktualny czas w milisekundach (Unix Epoch).
@_timer-start:
    #!/usr/bin/env bash
    echo "export AMBERO_START_TIME=$(date +%s%3N)"

# [EDU] Oblicza różnicę między czasem startu a obecnym.
@_timer-stop:
    #!/usr/bin/env bash
    END_TIME=$(date +%s%3N)
    DIFF=$((END_TIME - AMBERO_START_TIME))
    # Konwersja ms na sekundy z zachowaniem 2 miejsc po przecinku
    printf "%.2f" $(echo "scale=3; $DIFF/1000" | bc)
