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


@_timer-start:
    #!/usr/bin/env bash
    if command -v python3 >/dev/null 2>&1; then
        MS=$(python3 -c 'import time; print(int(time.time() * 1000))')
    else
        MS=$(date +%s)000
    fi
    echo "export AMBERO_START_TIME=$MS"

@_timer-stop:
    #!/usr/bin/env bash
    if command -v python3 >/dev/null 2>&1; then
        END=$(python3 -c 'import time; print(int(time.time() * 1000))')
    else
        END=$(date +%s)000
    fi
    DIFF=$((END - ${AMBERO_START_TIME:-$END}))
    echo "$DIFF" | LC_NUMERIC=C awk '{printf "%.2f", $1/1000}'
