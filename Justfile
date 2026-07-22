# =============================================================================
# PROJECT:          Ambero Framework CLI
# AUTHOR:           PyCoder Gabryl
# GITHUB:           https://github.com/PyCoder-Gabryl
# EMAIL:            pycoder.gabryl@gmail.com
# LICENSE:          Apache 2.0
# -----------------------------------------------------------------------------
# DESCRIPTION:      Główny router poleceń (CLI) frameworku Ambero.
#                   Wersja 0.3.1: Implementacja ręcznego sterowania verbosity.
# -----------------------------------------------------------------------------
# PATH:             Justfile
# VERSION:          0.3.1
# CREATED:          2026-07-16
# =============================================================================


set shell := ["bash", "-c"]
set quiet

# =============================================================================
# SEKCJA: USTAWIENIA KOMUNIKACJI (Manual Control)
# =============================================================================
# [EDU] Odkomentuj tylko JEDEN z poniższych trybów, aby zmienić zachowanie CLI.
# verbosity := "quiet"   # (q)   - Absolutna cisza, tylko surowy wynik.
# verbosity := "minimal" # (min) - Tylko kluczowe statusy sukcesu/błędu.
# verbosity := "prod"    # (p)   - Standardowe ramki i kroki operacji.
# verbosity := "edu"     # (e)   - Tryb produkcyjny + bloki edukacyjne.
verbosity := "dev"       # (d)   - Pełny debug (ID sesji, ścieżki, logi).


# =============================================================================
# SEKCJA: DETEKCJA ŚRODOWISKA
# =============================================================================
IS_DEV_ENV := `if [ -d .git ]; then echo "true"; else echo "false"; fi`


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
# SEKCJA: IMPORTY
# =============================================================================

import 'am_just/commands/colors.just'
import 'am_just/lib/check_config.just'
import 'am_just/lib/session.just'
import 'am_just/lib/timer.just'
import 'am_just/lib/ui_frames.just'
import 'am_just/lib/ui_msg.just'
import 'am_just/lib/verbosity.just'
import 'am_just/lib/logger_peek.just'
import 'am_just/lib/i18n_helper.just'
import 'am_just/commands/dir_view.just'
import 'am_just/commands/backup.just'
import 'am_just/commands/refresh_plugins.just'
import 'am_just/commands/plugin_show.just'
import 'am_just/commands/dev_help.just'
import 'am_just/commands/core.just'
import 'am_just/commands/official.just'
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
