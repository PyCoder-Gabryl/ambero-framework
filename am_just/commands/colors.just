# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Centralny rejestr kolorów i stylów ANSI dla Just.
#                   Zapewnia spójność wizualną komunikatów generowanych
#                   bezpośrednio przez receptury Justfile.
# ----------------------------------------------------------------------------
# PATH:            am_just/colors.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================

# =============================================================================
# SEKCJA 1: STYLE I RESETOWANIE
# =============================================================================
style_bold  := `printf "\033[1m"`
style_dim   := `printf "\033[2m"`
style_reset := `printf "\033[0m"`

# =============================================================================
# SEKCJA 2: PALETA KOLORÓW PODSTAWOWYCH
# =============================================================================
clr_red    := `printf "\033[31m"`
clr_green  := `printf "\033[32m"`
clr_yellow := `printf "\033[33m"`
clr_blue   := `printf "\033[34m"`
clr_purple := `printf "\033[35m"`
clr_cyan   := `printf "\033[36m"`

# Kolory pogrubione (Mocne)
clr_b_red    := `printf "\033[1;31m"`
clr_b_green  := `printf "\033[1;32m"`
clr_b_yellow := `printf "\033[1;33m"`
clr_b_blue   := `printf "\033[1;34m"`
clr_b_purple := `printf "\033[1;35m"`
clr_b_cyan   := `printf "\033[1;36m"`

# Kolor specjalny Ambero (256-color mode)
clr_amber    := `printf "\033[38;5;214m"`

# =============================================================================
# SEKCJA 3: MAPOWANIE SEMANTYCZNE (Statusy)
# =============================================================================
# [EDU] Mapowanie semantyczne pozwala na zmianę schematu kolorów całego
# frameworku w jednym miejscu, bez edycji dziesiątek plików .just.

clr_error   := clr_b_red
clr_warn    := clr_b_yellow
clr_success := clr_b_green
clr_info    := clr_b_cyan
clr_step    := clr_b_blue
