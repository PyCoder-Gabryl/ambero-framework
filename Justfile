# =============================================================================
# PROJECT:          Ambero Framework CLI
# AUTHOR:           PyCoder Gabryl
# GITHUB:           https://github.com/PyCoder-Gabryl
# EMAIL:            pycoder.gabryl@gmail.com
# LICENSE:          Apache 2.0
# -----------------------------------------------------------------------------
# DESCRIPTION:      Główny router poleceń (CLI) frameworku Ambero.
#                   Pełni rolę centralnego punktu wejścia, zarządzając
#                   importami modułów technicznych oraz wtyczek.
#                   Zapewnia izolację logiki poprzez delegację zadań.
# -----------------------------------------------------------------------------
# PATH:             Justfile
# VERSION:          0.2.3
# CREATED:          2026-07-16
# =============================================================================

set shell := ["bash", "-c"]

# [EDU] Zmienna 'verbosity' kontroluje ilość informacji wyświetlanych w terminalu.
# Dostępne poziomy: quiet (q), minimal (min), prod (p), edu (e), dev (d).
verbosity := "dev"

# =============================================================================
# SEKCJA: ZMIENNE GLOBALNE I KONFIGURACJA ŚRODOWISKA
# =============================================================================

AMBERO_NAME    := "AMBERO FRAMEWORK CLI"
AMBERO_VERSION := trim(read("VERSION"))

# Bezwzględna ścieżka do katalogu głównego frameworku
AMBERO_DIR := justfile_directory()
CONFIG_FILE := AMBERO_DIR + "/am_config/config.toml"
BACKUP_DIR := AMBERO_DIR + "/backups"

# Eksport zmiennej dla skryptów Amber (Source of Truth dla lokalizacji)
export AMBERO_HOME := AMBERO_DIR

# =============================================================================
# SEKCJA: IMPORTY MODUŁÓW I WTYCZEK
# =============================================================================

# 1. Biblioteki techniczne Just (am_just/commands)
import 'am_just/commands/colors.just'
import 'am_just/commands/ambero_dir.just'
import 'am_just/commands/backup.just'
import 'am_just/commands/refresh_plugins.just'
import 'am_just/commands/plugin_show.just'
import 'am_just/commands/dev_help.just'

# 2. Funkcje atomowe i UI (am_just/lib) [ODBLOKOWANE I UPORZĄDKOWANE]
import 'am_just/lib/check_config.just'
import 'am_just/lib/session.just'
import 'am_just/lib/timer.just'
import 'am_just/lib/ui_frames.just'
import 'am_just/lib/logger_peek.just'
import 'am_just/lib/i18n_helper.just'

# 3. Moduły specyficzne dla platformy
import 'am_just/platform/macos.just'
import 'am_just/platform/linux.just'
import 'am_just/platform/windows.just'

# 4. Rejestr dynamicznych wtyczek (am_plugins)
import 'am_plugins/plugins.just'

# 5. Oficjalna logika frameworku i wrappery
import 'am_just/commands/core.just'
import 'am_just/commands/official.just'

# =============================================================================
# SEKCJA: GŁÓWNA LOGIKA CLI
# =============================================================================

# Wyświetla listę wszystkich dostępnych poleceń frameworku
@_default:
    just --list

# Alias dla intuicyjności
help: _default
