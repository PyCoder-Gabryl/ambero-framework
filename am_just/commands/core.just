# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Rdzeń wykonawczy Just dla frameworku Ambero.
#                   Implementuje bezpieczny wrapper 'run-amber', który
#                   zarządza izolacją wtyczek poprzez symlinki am_core
#                   oraz gwarantuje czystość środowiska dzięki mechanizmowi trap.
# ----------------------------------------------------------------------------
# PATH:            am_just/core.just
# VERSION:         0.1.3
# CREATED:         2026-07-20
# ============================================================================


# [EDU] @_run-amber jako receptura shebang (#!/usr/bin/env bash).
# To najbardziej profesjonalny sposób łączenia Justa z Bashem.
# Just tworzy tymczasowy plik wykonywalny, co eliminuje błędy wcięć.
@_run-amber plugin_path: _check_config
    #!/usr/bin/env bash
    set -euo pipefail

    # --- KROK 1: INICJALIZACJA SESJI ---
    # [EDU] Przechwytujemy wynik zadania _init-session i wykonujemy go (eval),
    # aby zmienna AMBERO_SESSION_ID stała się dostępna w tym skrypcie.
    eval "$(just _init-session)"

    # --- KROK 2: NAZWA KOMENDY ---
    # Wycinamy nazwę pliku i zamieniamy podkreślniki na myślniki dla estetyki CLI.
    CMD_NAME=$(basename "{{plugin_path}}" .ab | tr "_" "-")

    # --- KROK 3: WARSTWA PREZENTACJI (NAGŁÓWEK) ---
    just _ui-header "$CMD_NAME"

    # --- KROK 4: PRZYGOTOWANIE IZOLACJI (SANDBOX) ---
    PLUGIN_DIR=$(dirname "{{plugin_path}}")
    CORE_LINK="{{AMBERO_DIR}}/$PLUGIN_DIR/am_core"

    # [EDU] Trap gwarantuje usunięcie symlinka nawet przy błędzie Ambera lub Ctrl+C.
    trap 'rm -f "$CORE_LINK"' EXIT INT TERM

    ln -sfn "{{AMBERO_DIR}}/am_core" "$CORE_LINK"

    # --- KROK 5: URUCHOMIENIE LOGIKI ---
    amber run "{{AMBERO_DIR}}/{{plugin_path}}"
