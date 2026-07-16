# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł instalacyjny dla systemu Debian i pochodnych.
#                   Zarządza aktualizacją bazy APT, instalacją niezbędnych
#                   narzędzi systemowych (curl, unzip) oraz pobieraniem
#                   binarek Just i Amber.
# ----------------------------------------------------------------------------
# PATH:            am_install/lib/platforms/debian.sh
# VERSION:         0.1.0
# CREATED:         2026-07-17
# ============================================================================


# Aktualizacja bazy pakietów APT
debian_update_system() {
    echo -e "${CLR_BLUE}${ICO_WAIT} Aktualizowanie bazy pakietów APT...${CLR_RESET}"
    sudo apt-get update -y
}

# Instalacja podstawowych narzędzi wymaganych przez instalator Ambero
debian_install_essentials() {
    echo -e "${CLR_BLUE}${ICO_PKG} Instalowanie niezbędnych narzędzi (curl, unzip, git)...${CLR_RESET}"
    sudo apt-get install -y curl unzip git
}

# Instalacja Just (Debian często nie ma go w oficjalnych repozytoriach lub ma starą wersję)
# Używamy oficjalnego skryptu instalacyjnego, który pobiera binarkę do /usr/local/bin
debian_install_just() {
    if check_bin "just"; then
        echo -e "${CLR_CYAN}${ICO_INFO} Just jest już zainstalowany.${CLR_RESET}"
    else
        echo -e "${CLR_BLUE}${ICO_PKG} Instalowanie Just (pobieranie binarki)...${CLR_RESET}"
        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
    fi
}

# Instalacja Amber (Oficjalny skrypt)
debian_install_amber() {
    if check_bin "amber"; then
        echo -e "${CLR_CYAN}${ICO_INFO} Amber jest już zainstalowany.${CLR_RESET}"
    else
        echo -e "${CLR_BLUE}${ICO_PKG} Instalowanie Amber (wersja 0.6.0-alpha)...${CLR_RESET}"
        curl -sSf https://amber-lang.com/install.sh | sh
    fi
}

# Zbiorcza funkcja instalacji dla Debiana
debian_full_install() {
    # Weryfikacja sudo (funkcja z utils.sh)
    check_sudo

    # Logika interwału aktualizacji
    local last_check
    last_check=$(grep "last_update_check" "${AMBERO_DIR}/config/config.toml" | cut -d'"' -f2)
    local diff
    diff=$(get_date_diff "$last_check")
    local interval
    interval=$(grep "update_interval_days" "${AMBERO_DIR}/config/config.toml" | awk '{print $3}')

    if [ "$diff" -ge "$interval" ]; then
        debian_update_system
        update_config_value "last_update_check" "$(date +%Y-%m-%d)"
    else
        echo -e "${CLR_CYAN}${ICO_INFO} Pomijam aktualizację APT (ostatnia była $diff dni temu).${CLR_RESET}"
    fi

    debian_install_essentials
    debian_install_just
    debian_install_amber
}
