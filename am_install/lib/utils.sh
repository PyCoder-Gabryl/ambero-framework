# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Biblioteka funkcji pomocniczych dla instalatora.
#                   Zawiera mechanizmy sprawdzania zależności, weryfikacji
#                   uprawnień administratora oraz logikę obliczania
#                   interwałów czasowych dla aktualizacji.
# ----------------------------------------------------------------------------
# PATH:            am_install/lib/utils.sh
# VERSION:         0.1.0
# CREATED:         2026-07-17
# ============================================================================


# Sprawdza czy podana komenda istnieje w systemie
# Argument: $1 - nazwa binarki
check_bin() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Weryfikuje uprawnienia sudo lub podaje instrukcję dla Debiana
check_sudo() {
    # Jeśli użytkownik to root, nie potrzebujemy sudo
    if [ "$EUID" -eq 0 ]; then
        return 0
    fi

    # Sprawdzamy czy sudo jest zainstalowane i czy mamy do niego prawa
    if check_bin "sudo" && sudo -n true >/dev/null 2>&1; then
        return 0
    fi

    # Jeśli nie mamy sudo, a jesteśmy na Debianie, wypisujemy instrukcję
    echo -e "${CLR_RED}${ICO_ERROR} Brak uprawnień administratora (sudo).${CLR_RESET}"
    echo -e "${CLR_YELLOW}${ICO_INFO} Aby kontynuować na czystym Debianie, wykonaj jako root:${CLR_RESET}"
    echo -e "${CLR_BOLD}su -c \"apt-get update && apt-get install -y sudo curl git && usermod -aG sudo $USER\"${CLR_RESET}"
    echo -e "${CLR_YELLOW}Następnie zaloguj się ponownie i uruchom instalator.${CLR_RESET}"
    exit 1
}

# Oblicza różnicę dni między datą w configu a dniem dzisiejszym
# Argument: $1 - data w formacie YYYY-MM-DD
# Zwraca: liczbę dni (integer)
get_date_diff() {
    local last_date=$1
    if [ -z "$last_date" ]; then
        echo "999" # Jeśli brak daty, wymuszamy aktualizację
        return
    fi

    local current_ts
    local last_ts
    current_ts=$(date +%s)

    if [ "$OS_TYPE" = "macos" ]; then
        last_ts=$(date -j -f "%Y-%m-%d" "$last_date" "+%s" 2>/dev/null || echo 0)
    else
        last_ts=$(date -d "$last_date" "+%s" 2>/dev/null || echo 0)
    fi

    local diff=$(( (current_ts - last_ts) / 86400 ))
    echo "$diff"
}

# Pomocnicza funkcja do aktualizacji wartości w config.toml (prosty sed)
# Argumenty: $1 - klucz, $2 - nowa wartość
update_config_value() {
    local key=$1
    local value=$2
    local config_file="${AMBERO_DIR}/config/config.toml"

    if [ -f "$config_file" ]; then
        # Używamy zmiennej SED_INPLACE zdefiniowanej w głównym instalatorze
        $SED_INPLACE "s/^${key} = .*/${key} = \"${value}\"/" "$config_file"
    fi
}
