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
# VERSION:          0.3.0
# CREATED:          2026-07-16
# =============================================================================


set shell := ["bash", "-c"]
set quiet

# =============================================================================
# SEKCJA: DETEKCJA ŚRODOWISKA I TRYBU PRACY
# =============================================================================
# [EDU] Sprawdzamy, czy pracujemy wewnątrz repozytorium (tryb deweloperski).
IS_DEV_ENV := `if [ -d .git ]; then echo "true"; else echo "false"; fi`

# Wartości domyślne (używane, gdy brak pliku config.toml)
DEFAULT_VERBOSITY   := if IS_DEV_ENV == "true" { "dev" } else { "prod" }
DEFAULT_INTERACTIVE := if IS_DEV_ENV == "true" { "true" } else { "false" }

# [ZMIANA] Zmienna verbosity może być nadpisana z linii komend, np. 'am task v=q'
verbosity := DEFAULT_VERBOSITY

# =============================================================================
# SEKCJA: ZMIENNE GLOBALNE
# =============================================================================
AMBERO_NAME    := "AMBERO FRAMEWORK CLI"
AMBERO_VERSION := trim(read("VERSION"))
AMBERO_DIR     := justfile_directory()

CONFIG_FILE    := AMBERO_DIR + "/am_config/config.toml"
BACKUP_DIR     := AMBERO_DIR + "/backups"

# Eksport dla Ambera - Source of Truth
export AMBERO_HOME := AMBERO_DIR

# =============================================================================
# SEKCJA: IMPORTY (JEDYNE MIEJSCE W SYSTEMIE)
# =============================================================================

# 1. Fundamenty wizualne i i18n
import 'am_just/commands/colors.just'

# 2. Silnik (lib) - Funkcje atomowe
import 'am_just/lib/check_config.just'
import 'am_just/lib/session.just'
import 'am_just/lib/timer.just'
import 'am_just/lib/ui_frames.just'
import 'am_just/lib/ui_msg.just'
import 'am_just/lib/verbosity.just'
import 'am_just/lib/logger_peek.just'
import 'am_just/lib/i18n_helper.just'

# 3. Polecenia techniczne (commands)
import 'am_just/commands/ambero_dir.just'
import 'am_just/commands/backup.just'
import 'am_just/commands/refresh_plugins.just'
import 'am_just/commands/plugin_show.just'
import 'am_just/commands/dev_help.just'
import 'am_just/commands/core.just'
import 'am_just/commands/official.just'

# 4. Platformy i Wtyczki
import 'am_just/platform/macos.just'
import 'am_just/platform/linux.just'
import 'am_just/platform/windows.just'
import 'am_plugins/plugins.just'

# =============================================================================
# SEKCJA: GŁÓWNA LOGIKA
# =============================================================================

@_default:
    just --list

help: _default
