# --- KOMUNIKATY I18N (Lokalne) ---
msg_backup_pack   := "📦 Pakowanie projektu do pakietu ZIP..."
msg_backup_verify := "🔍 Weryfikacja spójności archiwum (unzip -t)..."
msg_backup_clean  := "🧹 Czyszczenie starych kopii zapasowych..."
msg_backup_ok     := "✅ Archiwum spakowane i w pełni poprawne!"
msg_backup_path   := "📍 Ścieżka:"
msg_backup_size   := "📊 Rozmiar paczki:"

# ============================================================================
# SEKCJA: ZADANIA ARCHIWIZACJI
# ============================================================================

# Pakuje projekt do ZIP (włącza config.toml, pomija śmieci IDE i logi)
backup-project:
    @just _run-just "_backup-project-logic" "backup-project"

# [EDU] Blok wyjaśniający, co faktycznie kryje się pod spodem
@_backup-project-logic-edu:
    @just _ui-edu-block "Zadanie to tworzy bezpieczną i kompletną kopię zapasową projektu.\n\
        │ Najpierw wszystkie pliki pakowane są do archiwum tymczasowego,\n\
        │ które następnie jest poddawane rygorystycznym testom spójności (unzip -t).\n\
        │ Operacja celowo omija katalogi, takie jak '.git', 'logs/', 'backups/'\n\
        │ oraz pliki konfiguracyjne środowisk IDE (.idea, .vscode, .DS_Store).\n\
        │ Jeśli weryfikacja się powiedzie, stare paczki są kasowane."

# [DEV] Diagnostyka parametrów backupu (v0.3.2: Nowe obramowanie)
@_backup-project-logic-dev:
    @echo -e "{{clr_amber}}┌──────────────────────────────────────────────────────────{{style_reset}}"; \
    echo -e "{{clr_amber}}│{{style_reset}} {{clr_b_red}}DEBUG:{{style_reset}} {{clr_yellow}}Parametry archiwizacji:{{style_reset}}"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📂 Katalog:    {{BACKUP_DIR}}"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📦 Plik:       ambero_v{{AMBERO_VERSION}}.zip"; \
    echo -e "{{clr_amber}}│{{style_reset}} 🛠️  Metoda:     Atomic (zip -> unzip -t -> mv)"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📄 Zadanie:    am_just/commands/backup.just"; \
    echo -e "{{clr_amber}}└──────────────────────────────────────────────────────────{{style_reset}}"

[private]
[no-cd]
_backup-project-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    W=${AMBERO_VERBOSITY_WEIGHT:-2}

    B_DIR="{{BACKUP_DIR}}"
    A_DIR="{{AMBERO_DIR}}"
    PROJ_SLUG="ambero"
    B_NAME="${PROJ_SLUG}_v{{AMBERO_VERSION}}.zip"
    TEMP_NAME=".temp_${B_NAME}"

    mkdir -p "$B_DIR"

    # --- 1. ETAP PAKOWANIA (Tymczasowy plik) ---
    [ "$W" -ge 0 ] && echo -e "{{clr_info}}{{msg_backup_pack}}{{style_reset}}"

    cd "$A_DIR"
    # W trybie DEV (waga 4) nie wyciszamy wyjścia polecenia zip
    if [ "$W" -ge 4 ]; then
        zip -r "$B_DIR/$TEMP_NAME" . \
            -x ".git/*" -x ".idea/*" -x ".vscode/*" -x "*.iml" \
            -x "logs/*" -x "backups/*" -x ".DS_Store" -x "__MACOSX" \
            -x "Thumbs.db" -x "desktop.ini" -x "*~" -x "*.swp" -x ".fuse_hidden*"
    else
        zip -r "$B_DIR/$TEMP_NAME" . \
            -x ".git/*" -x ".idea/*" -x ".vscode/*" -x "*.iml" \
            -x "logs/*" -x "backups/*" -x ".DS_Store" -x "__MACOSX" \
            -x "Thumbs.db" -x "desktop.ini" -x "*~" -x "*.swp" -x ".fuse_hidden*" \
            > /dev/null
    fi

    # --- 2. ETAP WERYFIKACJI (Integrity check) ---
    [ "$W" -ge 1 ] && echo -e "{{clr_info}}{{msg_backup_verify}}{{style_reset}}"

    if [ "$W" -ge 4 ]; then
        unzip -t "$B_DIR/$TEMP_NAME"
    else
        unzip -t "$B_DIR/$TEMP_NAME" > /dev/null
    fi

    # --- 3. ETAP CZYSZCZENIA (Bezpieczne nadpisanie) ---
    [ "$W" -ge 1 ] && echo -e "{{clr_info}}{{msg_backup_clean}}{{style_reset}}"
    rm -f "$B_DIR"/*.zip
    mv "$B_DIR/$TEMP_NAME" "$B_DIR/$B_NAME"

    # --- 4. PODSUMOWANIE ---
    [ "$W" -ge 1 ] && echo -e "{{clr_success}}{{msg_backup_ok}}{{style_reset}}"

    echo -e "\n{{clr_amber}}{{msg_backup_path}}{{style_reset}} $B_DIR/$B_NAME"

    if [ "$W" -ge 1 ]; then
        SIZE=$(ls -lh "$B_DIR/$B_NAME" | awk '{print $5}')
        echo -e "{{clr_info}}{{msg_backup_size}} $SIZE{{style_reset}}"
    fi
    exit 0
