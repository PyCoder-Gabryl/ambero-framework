# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Silnik pomiaru czasu wykonania (Timer).
#                   Używa Pythona dla precyzji milisekundowej na macOS/Linux.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/timer.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================


# ============================================================================
# SEKCJA: POMIAR CZASU (START/STOP)
# ============================================================================

# Rejestruje czas startu w milisekundach
@_timer-start:
    @if command -v python3 >/dev/null 2>&1; then \
        MS=$(python3 -c 'import time; print(int(time.time() * 1000))'); \
    else \
        MS=$(date +%s)000; \
    fi; \
    echo "export AMBERO_START_TIME=$MS"

# Oblicza różnicę czasu i formatuje wynik do sekund
@_timer-stop:
    @if command -v python3 >/dev/null 2>&1; then \
        END=$(python3 -c 'import time; print(int(time.time() * 1000))'); \
    else \
        END=$(date +%s)000; \
    fi; \
    DIFF=$((END - ${AMBERO_START_TIME:-$END})); \
    echo "$DIFF" | LC_ALL=C awk '{printf "%.2f", $1/1000}'
