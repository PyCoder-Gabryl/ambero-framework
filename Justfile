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
# VERSION:          0.2.0
# CREATED:          2026-07-16
# =============================================================================

set shell := ["bash", "-c"]

verbosity := "dev" # UWAGA: Zmienić na "normal" przed wydaniem wersji STABLE.

# =============================================================================
# SEKCJA: ZMIENNE GLOBALNE I KONFIGURACJA ŚRODOWISKA
# =============================================================================

# Bezwzględna ścieżka do katalogu głównego frameworku
AMBERO_DIR := justfile_directory()
CONFIG_FILE := AMBERO_DIR + "/am_config/config.toml"
BACKUP_DIR := AMBERO_DIR + "/backups"

# Eksport zmiennej dla skryptów Amber (Source of Truth dla lokalizacji)
export AMBERO_HOME := AMBERO_DIR

AMBERO_NAME    := "AMBERO FRAMEWORK CLI"
AMBERO_VERSION := trim(read("VERSION"))

# =============================================================================
# SEKCJA: IMPORTY MODUŁÓW I WTYCZEK
# =============================================================================

# 1. Biblioteki techniczne Just (am_just)
import 'am_just/colors.just'
import 'am_just/ambero_dir.just'
import 'am_just/backup.just'
import 'am_just/refresh_plugins.just'
import 'am_just/plugin_show.just'

# 2. Moduły specyficzne dla platformy (Auto-detekcja)
import 'am_just/platform/macos.just'
import 'am_just/platform/linux.just'
import 'am_just/platform/windows.just'

# 3. Rejestr dynamicznych wtyczek (am_plugins)
import 'am_plugins/plugins.just'

# 4. Oficjalna logika frameworku (Przeniesione zadanie ambero)
import 'am_just/core.just'
import 'am_just/official.just'

# =============================================================================
# SEKCJA: GŁÓWNA LOGIKA CLI I ZADANIA SYSTEMOWE
# =============================================================================

# Wyświetla listę wszystkich dostępnych poleceń frameworku
@_default:
    just --list

# [EDU] Zadanie help jest aliasem do listy, aby zachować intuicyjność CLI.
help: _default

# Klauzula bezpieczeństwa: Weryfikuje obecność pliku konfiguracyjnego.
# Zapobiega błędom wykonania skryptów Amber przed inicjalizacją systemu.
@_check_config:
    if [ ! -f "{{CONFIG_FILE}}" ]; then \
        echo "❌ Błąd krytyczny: Brak pliku konfiguracji {{CONFIG_FILE}}!"; \
        echo "👉 Uruchom instalator (am_install/install.sh), aby wygenerować system."; \
        exit 1; \
    fi

# =============================================================================
# KOMENTARZ EDUKACYJNY (JUST)
# =============================================================================
# 1. Używamy 'import' zamiast 'include', co jest standardem w nowym Just.
# 2. Zmienne zdefiniowane w głównym Justfile są widoczne w importowanych plikach.
# 3. Zadania zaczynające się od '_' są ukryte w widoku 'just --list'.
# 4. Dyrektywa [no-cd] (jeśli użyta) zapobiega zmianie katalogu roboczego.
