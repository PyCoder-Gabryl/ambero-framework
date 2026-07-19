# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Główny router poleceń (CLI) frameworku Ambero.
#                   Odpowiada za przyjmowanie argumentów od użytkownika,
#                   weryfikację stanu konfiguracji (sanity check) oraz
#                   przekazywanie wykonania do skryptów Amber.
# ----------------------------------------------------------------------------
# PATH:            Justfile
# VERSION:         0.1.10
# CREATED:         2026-07-16
# ============================================================================

set shell := ["bash", "-c"]

# =============================================================================
# ZMIENNE GLOBALNE I ŚCIEŻKI
# =============================================================================
AMBERO_DIR := justfile_directory()
CONFIG_FILE := AMBERO_DIR + "/config/config.toml"
BACKUP_DIR := AMBERO_DIR + "/backups"

# Eksportujemy ścieżkę domową, aby skrypty Amber mogły ją łatwo odczytać z otoczenia
export AMBERO_HOME := AMBERO_DIR

# 1. CENTRALNE KOLORY - Ładowane jako pierwsze, aby zasilić pozostałe moduły
import 'justfiles/colors.just'

# 2. POZOSTAŁE MODUŁY POMOCNICZE I AUTOMATYCZNE WTYCZKI
import 'am_plugins/plugins.just'
import 'justfiles/ambero_dir.just'
import 'justfiles/backup.just'
import 'justfiles/refresh_plugins.just'
import 'justfiles/plugin_show.just'

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

# Główne powitanie, diagnostyka i podgląd konfiguracji Ambero Framework CLI
ambero: _check_config
	@rm -rf {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
	@ln -sfn {{AMBERO_DIR}}/am_core {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
	@amber run am_plugins/official/ambero/ambero_welcome.ab
	@rm -rf {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
	@ln -sfn {{AMBERO_DIR}}/am_core {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
	@amber run am_plugins/official/ambero/ambero_info_dev.ab
	@rm -rf {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
	@ln -sfn {{AMBERO_DIR}}/am_core {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
	@amber run am_plugins/official/ambero/ambero_dir_view.ab
	@rm -rf {{AMBERO_DIR}}/am_plugins/official/ambero/am_core
