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

# Pobiera aktualny czas w milisekundach (Cross-platform: macOS/Linux)
@_timer-start:
    #!/usr/bin/env bash
    # Używamy python3 dla milisekund, bo 'date' na macOS nie obsługuje %N
    MS=$(python3 -c 'import time; print(int(time.time() * 1000))')
    echo "export AMBERO_START_TIME=$MS"

# Oblicza różnicę czasu
@_timer-stop:
    #!/usr/bin/env bash
    END_TIME=$(python3 -c 'import time; print(int(time.time() * 1000))')
    DIFF=$((END_TIME - AMBERO_START_TIME))
    # Obliczanie sekund przez awk dla pełnej przenośności
    echo "$DIFF" | awk '{printf "%.2f", $1/1000}'
