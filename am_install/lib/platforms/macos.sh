# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł instalacyjny dla systemu macOS. Wykorzystuje
#                   menedżer pakietów Homebrew do instalacji narzędzia Just
#                   oraz oficjalny skrypt instalacyjny dla języka Amber.
#                   Obsługuje weryfikację środowiska i aktualizację Homebrew.
# ----------------------------------------------------------------------------
# PATH:            am_install/lib/platforms/macos.sh
# VERSION:         0.1.0
# CREATED:         2026-07-17
# ============================================================================

# Funkcja sprawdzająca i przygotowująca Homebrew
macos_prepare_brew() {
    if ! check_bin "brew"; then
        echo -e "${CLR_YELLOW}${ICO_WARN} Brak Homebrew. Rozpoczynam instalację...${CLR_RESET}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Ustawienie ścieżki dla Apple Silicon (M1/M2/M3)
        if [ -f "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo -e "${CLR_GREEN}${ICO_OK} Homebrew jest zainstalowany.${CLR_RESET}"
    fi
}

# Aktualizacja bazy pakietów (wywoływana na podstawie interwału z configu)
macos_update_system() {
    echo -e "${CLR_BLUE}${ICO_WAIT} Aktualizowanie bazy Homebrew (może to chwilę potrwać)...${CLR_RESET}"
    brew update
}

# Instalacja Just przez Brew
macos_install_just() {
    if brew list just >/dev/null 2>&1; then
        echo -e "${CLR_CYAN}${ICO_INFO} Just jest już zainstalowany. Sprawdzam aktualizacje...${CLR_RESET}"
        brew upgrade just
    else
        echo -e "${CLR_BLUE}${ICO_PKG} Instalowanie Just...${CLR_RESET}"
        brew install just
    fi
}

# Instalacja Amber (Oficjalny instalator, ponieważ Amber jest w fazie alfa)
macos_install_amber() {
    if check_bin "amber"; then
        echo -e "${CLR_CYAN}${ICO_INFO} Amber jest już zainstalowany.${CLR_RESET}"
        # Opcjonalnie: tutaj można dodać logikę sprawdzania wersji i ponownej instalacji
    else
        echo -e "${CLR_BLUE}${ICO_PKG} Instalowanie Amber (wersja 0.6.0-alpha)...${CLR_RESET}"
        curl -sSf https://amber-lang.com/install.sh | sh
    fi
}

# Zbiorcza funkcja instalacji dla macOS
macos_full_install() {
    macos_prepare_brew

    # Logika interwału aktualizacji (wykorzystuje funkcję z utils.sh)
    local last_check
    last_check=$(grep "last_update_check" "${AMBERO_DIR}/config/config.toml" | cut -d'"' -f2)
    local diff
    diff=$(get_date_diff "$last_check")
    local interval
    interval=$(grep "update_interval_days" "${AMBERO_DIR}/config/config.toml" | awk '{print $3}')

    if [ "$diff" -ge "$interval" ]; then
        macos_update_system
        update_config_value "last_update_check" "$(date +%Y-%m-%d)"
    else
        echo -e "${CLR_CYAN}${ICO_INFO} Pomijam aktualizację Homebrew (ostatnia była $diff dni temu).${CLR_RESET}"
    fi

    macos_install_just
    macos_install_amber
}
