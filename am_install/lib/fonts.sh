# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł odpowiedzialny za wykrywanie i instalację
#                   czcionek typu Nerd Font. Obsługuje macOS oraz Linux.
# ----------------------------------------------------------------------------
# PATH:            am_install/lib/fonts.sh
# VERSION:         0.1.0
# CREATED:         2026-07-16
# ============================================================================

# Ścieżki czcionek zależne od OS
if [ "$OS_TYPE" = "macos" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

check_nerd_font() {
    local font_name=$1
    # Proste sprawdzenie czy plik czcionki istnieje w katalogu
    # shellcheck disable=SC2010
    if ls "$FONT_DIR" | grep -iq "$font_name"; then
        return 0 # Jest
    else
        return 1 # Brak
    fi
}

install_jb_mono_nerd() {
    echo -e "${CLR_BLUE}${ICO_PKG} Pobieranie JetBrains Mono Nerd Font...${CLR_RESET}"
    local tmp_dir=$(mktemp -d)
    curl -L -o "$tmp_dir/jb.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o "$tmp_dir/jb.zip" -d "$FONT_DIR"

    if [ "$OS_TYPE" != "macos" ]; then
        fc-cache -f "$FONT_DIR"
    fi
    echo -e "${CLR_GREEN}${ICO_OK} Zainstalowano pomyślnie!${CLR_RESET}"
}
