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
# VERSION:         0.1.1
# CREATED:         2026-07-16
# ============================================================================

set shell := ["bash", "-c"]

# =============================================================================
# ZMIENNE GLOBALNE I ŚCIEŻKI
# =============================================================================
AMBERO_DIR := justfile_directory()
CONFIG_FILE := AMBERO_DIR + "/config/config.toml"

# Eksportujemy ścieżkę domową, aby skrypty Amber mogły ją łatwo odczytać z otoczenia
export AMBERO_HOME := AMBERO_DIR

# Importujemy automatycznie generowaną listę zadań z wtyczek
import 'am_plugins/plugins.just' # [NOWA]

# =============================================================================
# GŁÓWNA LOGIKA CLI
# =============================================================================

@_default:
    just --list

# =============================================================================
# UKRYTE ZADANIA SYSTEMOWE
# =============================================================================

@_check_config:
    if [ ! -f "{{CONFIG_FILE}}" ]; then \
        echo "❌ Błąd krytyczny: Brak pliku konfiguracyjnego {{CONFIG_FILE}}!"; \
        echo "👉 Uruchom instalator (am_install/install.sh), aby wygenerować konfigurację."; \
        exit 1; \
    fi

# =============================================================================
# MODUŁ: OFFICIAL (AMBERO)
# =============================================================================

# Powitanie Ambero (Test środowiska i poprawnego linkowania)
@ambero: _check_config
    amber run {{AMBERO_DIR}}/am_plugins/official/ambero/hello/hello.ab # [ZMIENIONA ŚCIEŻKA]
