# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Główny router poleceń (CLI) frameworku Ambero.
#                   Odpowiada za przyjmowanie argumentów od użytkownika,
#                   weryfikację stanu konfiguracji (sanity check) oraz
#                   przekazywanie wykonania do skryptów Amber.
# ----------------------------------------------------------------------------
# PATH:            Justfile
# VERSION:         0.1.0
# CREATED:         2026-07-16
# ============================================================================

set shell := ["bash", "-c"]

# =============================================================================
# ZMIENNE GLOBALNE I ŚCIEŻKI
# =============================================================================
# justfile_directory() zwraca absolutną ścieżkę do katalogu, w którym leży ten Justfile.
# Dzięki temu aliasy globalne działają niezależnie od obecnego katalogu roboczego (PWD).
AMBERO_DIR := justfile_directory()
CONFIG_FILE := AMBERO_DIR + "/config/config.toml"

# =============================================================================
# GŁÓWNA LOGIKA CLI
# =============================================================================

# Domyślna komenda wywoływana, gdy użytkownik wpisze samo 'am' lub 'ambero'
@_default:
    just --list

# =============================================================================
# UKRYTE ZADANIA SYSTEMOWE (Zaczynają się od '_')
# =============================================================================

# Klauzula bezpieczeństwa (Self-healing sanity check).
# Uruchamiana jako zależność przed właściwymi komendami.
@_check_config:
    if [ ! -f "{{CONFIG_FILE}}" ]; then \
        echo "❌ Błąd krytyczny: Brak pliku konfiguracyjnego {{CONFIG_FILE}}!"; \
        echo "👉 Uruchom instalator (am_install/install.sh), aby wygenerować konfigurację."; \
        exit 1; \
    fi

# =============================================================================
# MODUŁ: CORE
# =============================================================================

# Powitanie Ambero (Test środowiska i poprawnego linkowania)
@ambero: _check_config
    amber run {{AMBERO_DIR}}/am_modules/core/hello.ab
