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
# VERSION:         0.1.3
# CREATED:         2026-07-16
# ============================================================================

# shellcheck disable=SC2162

# Ścieżki czcionek zależne od OS
if [ "$OS_TYPE" = "macos" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

# Sprawdza czy jakakolwiek czcionka Nerd Font jest w systemie
check_nerd_font_installed() {
    mkdir -p "$FONT_DIR"
    local f # [ZMIENIONE]
    for f in "$FONT_DIR"/*Nerd*Font*; do
        if [ -e "$f" ]; then
            return 0
        fi
    done # [ZMIENIONE]
    return 1
}

# Główna funkcja instalacyjna z menu wyboru
install_fonts_menu() {
    echo -e "${CLR_CYAN}${ICO_INFO} Wybierz czcionkę Nerd Font do zainstalowania:${CLR_RESET}"
    echo -e "1) JetBrains Mono Nerd Font (Zalecane)"
    echo -e "2) Hack Nerd Font"
    echo -e "3) Fira Code Nerd Font"
    echo -e "4) Wszystkie powyższe"
    echo -e "5) Pomiń instalację czcionek"

    local choice
    read -p "Wybór [1-5]: " choice

    case $choice in
        1) install_font "JetBrainsMono" ;;
        2) install_font "Hack" ;;
        3) install_font "FiraCode" ;;
        4)
            install_font "JetBrainsMono"
            install_font "Hack"
            install_font "FiraCode"
            ;;
        *) return 0 ;;
    esac
}

# Funkcja pomocnicza do pobierania i rozpakowywania
install_font() {
    local font_slug=$1
    local tmp_dir

    echo -e "${CLR_BLUE}${ICO_PKG} Instalowanie ${font_slug}...${CLR_RESET}"

    tmp_dir=$(mktemp -d)

    curl -L -o "$tmp_dir/font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_slug}.zip"

    unzip -o "$tmp_dir/font.zip" "*.ttf" "*.otf" -d "$FONT_DIR" > /dev/null

    if [ "$OS_TYPE" != "macos" ]; then
        fc-cache -f "$FONT_DIR" > /dev/null
    fi

    rm -rf "$tmp_dir"

    echo -e "${CLR_GREEN}${ICO_OK} Czcionka ${font_slug} gotowa!${CLR_RESET}"
}
