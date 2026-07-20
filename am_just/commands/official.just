# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Zbiór oficjalnych zadań administracyjnych Ambero.
#                   Zawiera komendy diagnostyczne, powitalne oraz
#                   raporty o stanie środowiska deweloperskiego.
# ----------------------------------------------------------------------------
# PATH:            am_just/official.just
# VERSION:         0.1.0
# CREATED:         2026-07-20
# ============================================================================


# Główne powitanie, diagnostyka i podgląd konfiguracji Ambero Framework CLI
ambero:
    @just _run-amber "am_plugins/official/ambero/ambero_welcome.ab"
    @just _run-amber "am_plugins/official/ambero/ambero_info_dev.ab"
    @just _run-amber "am_plugins/official/ambero/ambero_dir_view.ab"
