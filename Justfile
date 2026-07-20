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
# -----------------------------------------------------------------------------
# PATH:             Justfile
# VERSION:          0.2.1
# CREATED:          2026-07-16
# =============================================================================

set shell := ["bash", "-c"]

# =============================================================================
# SYSTEM GADATLIWOŚCI (VERBOSITY)
# =============================================================================
# [EDU] Zmienna 'verbosity' kontroluje ilość informacji wyświetlanych w terminalu.
# Dostępne poziomy:
#   - 'quiet'   (q)   : Tylko surowy wynik (payload).
#   - 'minimal' (min) : Tylko kluczowe statusy, bez ramek UI.
#   - 'prod'    (p)   : Standardowy tryb produkcyjny (Nagłówek, Stopka, Status).
#   - 'edu'     (e)   : Tryb produkcyjny + dodatkowe bloki edukacyjne.
#   - 'dev'     (d)   : Pełny debug (UUID sesji, ścieżki, kody wyjścia).
#
# UWAGA: Obecnie wymuszono 'dev' dla celów deweloperskich. W wersji stabilnej
# wartość ta będzie nadpisywana dynamicznie przez ustawienie z am_config/config.toml.
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

# 1. Biblioteki techniczne Just (am_just)
import 'am_just/colors.just'
import 'am_just/ambero_dir.just'
import 'am_just/backup.just'
import 'am_just/refresh_plugins.just'
import 'am_just/plugin_show.just'
import 'am_just/dev_help.just'

# 2. Funkcje atomowe (am_just/lib)
import 'am_just/lib/check_config.just'
import 'am_just/lib/session.just'
import 'am_just/lib/timer.just'

# 3. Moduły specyficzne dla platformy
import 'am_just/platform/macos.just'
import 'am_just/platform/linux.just'
import 'am_just/platform/windows.just'

# 4. Rejestr dynamicznych wtyczek (am_plugins)
import 'am_plugins/plugins.just'

# 5. Oficjalna logika frameworku
import 'am_just/core.just'
import 'am_just/official.just'

# =============================================================================
# SEKCJA: GŁÓWNA LOGIKA CLI
# =============================================================================

# Wyświetla listę wszystkich dostępnych poleceń frameworku
@_default:
    just --list

# Alias dla intuicyjności
help: _default
