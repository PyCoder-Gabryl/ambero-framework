# ============================================================================
# PROJECT:         Ambero Framework CLI
# DESCRIPTION:     Automatycznie wygenerowany rejestr wtyczek.
#                  UWAGA: Ten plik jest generowany automatycznie.
#                  Ręczne zmiany zostaną nadpisane przy odświeżeniu!
# ----------------------------------------------------------------------------
# PATH:            am_plugins/plugins.just
# ============================================================================

# Wyświetla informacje o autorze i licencji Ambero Framework.
ambero-author: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/ambero_author.ab'

# Oficjalny, cieniowany baner blokowy Ambero (Zielono-Niebieski).
ambero-banner: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/ambero_banner.ab'

# Służy do surowej walidacji strukturalnej plików mapowania TOML.
ambero-dir-view: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/ambero_dir_view.ab'

# Wyświetla głęboki raport deweloperski bez powielania podstawowych wersji.
ambero-info-dev: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/ambero_info_dev.ab'

# Wyświetla szczegółowy raport o wersjach i środowisku CLI.
ambero-info: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/ambero_info.ab'

# Uruchamia pełną sekwencję powitalną i diagnostyczną frameworku.
ambero-welcome: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/official/ambero/ambero_welcome.ab'

# Wstrzykuje ścieżki Homebrew do plików RC dla IDE na macOS.
amber-jetbrain: _check_config
    @bash -c 'trap "rm -rf /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/experimental/jetbrains/macos/am_core" EXIT INT TERM; \
        ln -sfn /Users/pygamiq/Documents/InteliIDEA/ambero/am_core /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/experimental/jetbrains/macos/am_core; \
        amber run /Users/pygamiq/Documents/InteliIDEA/ambero/am_plugins/experimental/jetbrains/macos/amber_jetbrain.ab'

