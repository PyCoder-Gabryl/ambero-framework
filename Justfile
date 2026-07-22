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
# VERSION:          0.2.5
# CREATED:          2026-07-16
# =============================================================================


set shell := ["bash", "-c"]
set quiet

verbosity := "dev"

# =============================================================================
# SEKCJA: ZMIENNE GLOBALNE
# =============================================================================
AMBERO_NAME    := "AMBERO FRAMEWORK CLI"
AMBERO_VERSION := trim(read("VERSION"))
AMBERO_DIR     := justfile_directory()

CONFIG_FILE    := AMBERO_DIR + "/am_config/config.toml"
BACKUP_DIR     := AMBERO_DIR + "/backups"

export AMBERO_HOME := AMBERO_DIR

# =============================================================================
# SEKCJA: IMPORTY (JEDYNE MIEJSCE W SYSTEMIE)
# =============================================================================

# 1. Fundamenty wizualne
import 'am_just/commands/colors.just'

# 2. Silnik (lib) - TU SĄ TWOJE RECEPTURY _init-session ITP.
import 'am_just/lib/check_config.just'
import 'am_just/lib/session.just'
import 'am_just/lib/timer.just'
import 'am_just/lib/ui_frames.just'
import 'am_just/lib/logger_peek.just'
import 'am_just/lib/i18n_helper.just'

# 3. Polecenia (commands)
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
