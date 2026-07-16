#!/usr/bin/env bash


# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Główny skrypt instalacyjny frameworku Ambero.
#                   Odpowiada za detekcję systemu, wybór trybu (DEV/PROD),
#                   instalację zależności, generowanie konfiguracji
#                   oraz tworzenie wrapperów CLI w ~/.local/bin.
# ----------------------------------------------------------------------------
# PATH:            am_install/install.sh
# VERSION:         0.1.2
# CREATED:         2026-07-17
# ============================================================================


# =============================================================================
# 1. USTALANIE ŚCIEŻEK I ŁADOWANIE MODUŁÓW
# =============================================================================

# Bezwzględna ścieżka do katalogu, w którym znajduje się instalator
INSTALLER_SELF_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AMBERO_SOURCE_DIR="$(cd "$INSTALLER_SELF_PATH/.." && pwd)"

# Ładowanie bibliotek pomocniczych
source "$INSTALLER_SELF_PATH/lib/colors.sh"
source "$INSTALLER_SELF_PATH/lib/icons.sh"
source "$INSTALLER_SELF_PATH/lib/utils.sh"
source "$INSTALLER_SELF_PATH/lib/fonts.sh"

# Detekcja OS i ładowanie modułu platformy
OS_TYPE="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
    source "$INSTALLER_SELF_PATH/lib/platforms/macos.sh"
    SED_INPLACE=(sed -i '')
elif [[ -f /etc/debian_version ]]; then
    OS_TYPE="debian"
    source "$INSTALLER_SELF_PATH/lib/platforms/debian.sh"
    SED_INPLACE=(sed -i)
else
    echo -e "\033[0;31m❌ Nieobsługiwany system operacyjny.\033[0m"
    exit 1
fi

# Inicjalizacja ikon (domyślnie emoji, config może to zmienić później)
setup_icons "emoji"

# =============================================================================
# 2. INTERAKTYWNY WYBÓR TRYBU
# =============================================================================

clear
echo -e "${CLR_AMBER}${CLR_BOLD}🦖 Witaj w instalatorze Ambero Framework!${CLR_RESET}"
echo -e "------------------------------------------------------------"
echo -e "Wybierz zakres instalacji:"
echo -e "1) ${CLR_BOLD}PROD${CLR_RESET} (Instalacja w ~/.local/share/ambero - do codziennej pracy)"
echo -e "2) ${CLR_BOLD}DEV${CLR_RESET}  (Ustawienie projektu w bieżącym katalogu jako deweloperski)"
echo -e "3) ${CLR_BOLD}OBA${CLR_RESET}  (Zalecane dla twórców frameworku)"
echo -e "4) Anuluj"

read -rp "Wybór [1-4]: " INSTALL_MODE_CHOICE

case $INSTALL_MODE_CHOICE in
    1) MODE="PROD" ;;
    2) MODE="DEV" ;;
    3) MODE="BOTH" ;;
    *) echo "Anulowano."; exit 0 ;;
esac

# =============================================================================
# 3. REALIZACJA INSTALACJI
# =============================================================================

# A. Sprawdzenie uprawnień i instalacja zależności (Just, Amber)
if [ "$OS_TYPE" = "macos" ]; then
    macos_full_install
else
    debian_full_install
fi

# B. Przygotowanie katalogów i plików
PROD_DIR="$HOME/.local/share/ambero"
BIN_DIR="$HOME/.local/bin"
CONF_DIR_GLOBAL="$HOME/.config/ambero"
mkdir -p "$BIN_DIR" "$CONF_DIR_GLOBAL"

# C. Generowanie config.toml (jeśli nie istnieje)
if [ ! -f "$AMBERO_SOURCE_DIR/config/config.toml" ]; then
    echo -e "${CLR_BLUE}${ICO_WAIT} Generowanie konfiguracji...${CLR_RESET}"
    cp "$AMBERO_SOURCE_DIR/config/config.example.toml" "$AMBERO_SOURCE_DIR/config/config.toml"

    # Ustawienie ścieżki domowej w configu
    if [ "$MODE" = "DEV" ] || [ "$MODE" = "BOTH" ]; then
        update_config_value "ambero_home" "$AMBERO_SOURCE_DIR"
    else
        update_config_value "ambero_home" "$PROD_DIR"
    fi
    update_config_value "os_type" "$OS_TYPE"
fi

# D. Instalacja PROD (Kopiowanie plików)
if [ "$MODE" = "PROD" ] || [ "$MODE" = "BOTH" ]; then
    echo -e "${CLR_BLUE}${ICO_WAIT} Kopiowanie plików do $PROD_DIR...${CLR_RESET}"
    mkdir -p "$PROD_DIR"
    cp -R "$AMBERO_SOURCE_DIR/"* "$PROD_DIR/"
fi

# E. Tworzenie wrapperów CLI (Zamiast aliasów)
echo -e "${CLR_BLUE}${ICO_WAIT} Tworzenie wrapperów w $BIN_DIR...${CLR_RESET}"

# Wrapper 'am' (Zawsze PROD)
cat <<EOF > "$BIN_DIR/am"
#!/usr/bin/env bash
just -f "$PROD_DIR/Justfile" "\$@"
EOF

# Wrapper 'ambero' (DEV z fallbackiem do PROD)
cat <<EOF > "$BIN_DIR/ambero"
#!/usr/bin/env bash
if [ -f "./Justfile" ] && grep -q "PROJECT:.*Ambero" "./Justfile"; then
    just "\$@"
else
    just -f "$PROD_DIR/Justfile" "\$@"
fi
EOF

chmod +x "$BIN_DIR/am" "$BIN_DIR/ambero"

# F. Konfiguracja powłoki (Drop-in file)
ENV_FILE="$CONF_DIR_GLOBAL/env.sh"
echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" > "$ENV_FILE"

SHELL_RC="$HOME/.zshrc"
[ "$OS_TYPE" = "debian" ] && SHELL_RC="$HOME/.bashrc"

if ! grep -q "ambero/env.sh" "$SHELL_RC"; then
    echo -e "${CLR_BLUE}${ICO_WAIT} Dodawanie Ambero do $SHELL_RC...${CLR_RESET}"
    echo -e "\n# Ambero Framework Environment\n[ -f \"$ENV_FILE\" ] && source \"$ENV_FILE\"" >> "$SHELL_RC"
fi

# G. Opcjonalna instalacja czcionek
if ! check_nerd_font_installed; then
    install_fonts_menu
fi

# =============================================================================
# 4. PODSUMOWANIE
# =============================================================================

echo -e "\n${CLR_GREEN}${ICO_OK} Instalacja zakończona pomyślnie!${CLR_RESET}"
echo -e "------------------------------------------------------------"
echo -e "👉 Uruchom: ${CLR_BOLD}source $SHELL_RC${CLR_RESET} aby odświeżyć terminal."
echo -e "👉 Następnie wpisz: ${CLR_BOLD}am ambero${CLR_RESET} lub ${CLR_BOLD}ambero ambero${CLR_RESET}"
echo -e "------------------------------------------------------------"
