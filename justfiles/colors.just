# =============================================================================
# CENTRALNY REJESTR KOLORÓW ANSI DLA MODUŁÓW JUST
# =============================================================================

# Style tekstu
style_bold  := `printf "\033[1m"`
style_reset := `printf "\033[0m"`

# Kolory podstawowe
clr_red    := `printf "\033[31m"`
clr_green  := `printf "\033[32m"`
clr_yellow := `printf "\033[33m"`
clr_blue   := `printf "\033[34m"`
clr_purple := `printf "\033[35m"`
clr_cyan   := `printf "\033[36m"`

# Kolory pogrubione (Mocne)
clr_b_green  := `printf "\033[1;32m"`
clr_b_blue   := `printf "\033[1;34m"`
clr_b_purple := `printf "\033[1;35m"`
clr_b_cyan   := `printf "\033[1;36m"`
