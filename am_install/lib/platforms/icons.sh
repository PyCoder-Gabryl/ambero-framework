# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Logika wyboru ikon dla interfejsu CLI. Obsługuje tryb
#                   standardowych Emoji oraz zaawansowany tryb Nerd Fonts.
# ----------------------------------------------------------------------------
# PATH:            am_install/lib/platforms/icons.sh
# VERSION:         0.1.0
# CREATED:         2026-07-16
# ============================================================================

# shellcheck disable=SC2034

# Funkcja inicjująca ikony na podstawie trybu z konfiguracji
# Argument: $1 - tryb (emoji / nerd)
setup_icons() {
    local mode=$1

    if [ "$mode" = "nerd" ]; then
        # Ikony dla Nerd Fonts
        ICO_INFO="󰋽"
        ICO_OK="󰄬"
        ICO_WARN=""
        ICO_ERROR="󰅙"
        ICO_PKG="󰏖"
        ICO_WAIT="󱑮"
    else
        # Ikony standardowe (Emoji)
        ICO_INFO="ℹ️"
        ICO_OK="✅"
        ICO_WARN="⚠️"
        ICO_ERROR="❌"
        ICO_PKG="📦"
        ICO_WAIT="⏳"
    fi
}
