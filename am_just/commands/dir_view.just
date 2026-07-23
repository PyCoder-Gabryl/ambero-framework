# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator mapy ścieżek frameworku. Odpowiada za
#                   tworzenie i aktualizację pliku ambero_paths.toml.
#                   Wersja 0.4.1: Unifikacja widoku (zawsze pełne drzewo).
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/dir_view.just
# VERSION:         0.4.1
# CREATED:         2026-07-20
# ============================================================================

# Generuje lub aktualizuje plik konfiguracyjny ze ścieżkami
map-paths:
    @just _run-just "_map-paths-logic" "map-paths"

# Drukuje zmapowane sekcje i ścieżki w czytelny sposób
dir-view:
    @just _run-just "_dir-view-logic" "dir-view"

# [EDU] Wyjaśnienie roli mapowania ścieżek (v0.3.9: Nowe obramowanie w ui_msg)
@_dir-view-logic-edu:
    @just _ui-edu-block "Plik ambero_paths.toml to 'mapa drogowa' systemu.\n\
        │ Pozwala on na uniknięcie sztywnych ścieżek w kodzie Amber.\n\
        │ Dzięki temu wtyczki mogą być przenoszone między folderami\n\
        │ bez konieczności zmiany logiki skryptów. Każdy moduł Ambero\n\
        │ importuje 'am_core/path.ab', aby poznać swoje otoczenie."

# [DEV] Diagnostyka ścieżek (v0.3.9: Nowe ustandaryzowane obramowanie)
@_dir-view-logic-dev:
    @echo -e "{{clr_amber}}┌──────────────────────────────────────────────────────────{{style_reset}}"; \
    echo -e "{{clr_amber}}│{{style_reset}} {{clr_b_red}}DEBUG:{{style_reset}} {{clr_yellow}}Lokalizacja pliku ścieżek:{{style_reset}}"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📂 {{AMBERO_DIR}}/am_config/ambero_paths.toml"; \
    echo -e "{{clr_amber}}│{{style_reset}} 🛠️  Generator: am_just/commands/dir_view.just [dir-view]"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📄 Plik zadania: am_just/commands/dir_view.just"; \
    echo -e "{{clr_amber}}└──────────────────────────────────────────────────────────{{style_reset}}"

[no-cd]
_map-paths-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"
    HEADER_TMPL="{{AMBERO_DIR}}/am_config/templates/header_generated.txt"
    TMP_FILE=$(mktemp)
    GEN_DATE=$(date "+%Y-%m-%d %H:%M:%S")
    DESC="Automatyczny rejestr ścieżek systemowych frameworku Ambero."

    if test -f "$HEADER_TMPL"; then
        sed -e "s/{{ "{{" }}PROJECT_NAME}}/{{AMBERO_NAME}}/g" \
            -e "s/{{ "{{" }}GEN_DATE}}/$GEN_DATE/g" \
            -e "s/{{ "{{" }}DESCRIPTION}}/$DESC/g" \
            -e "s/{{ "{{" }}VERSION}}/{{AMBERO_VERSION}}/g" \
            -e "s|{{ "{{" }}FILE_PATH}}|am_config/ambero_paths.toml|g" \
            "$HEADER_TMPL" > "$TMP_FILE"
    else
        echo "# Generated: $GEN_DATE" > "$TMP_FILE"
    fi

    {
        echo ""
        echo "[system]"
        echo "core = \"am_core\""
        echo "config = \"am_config\""
        echo "logs = \"logs\""
        echo ""
        echo "[install]"
        echo "root = \"am_install\""
        echo "platforms = \"am_install/lib/platforms\""
        echo ""
        echo "[just]"
        echo "root = \"am_just\""
        echo "commands = \"am_just/commands\""
        echo "lib = \"am_just/lib\""
        echo ""
        echo "[plugins]"
        echo "root = \"am_plugins\""
        echo "experimental = \"am_plugins/experimental\""
        echo "official = \"am_plugins/official\""
        echo "user = \"am_plugins/user\""
        echo ""
        echo "[i18n]"
        echo "root = \"i18n\""
        echo "en_experimental = \"i18n/en/experimental\""
        echo "en_official = \"i18n/en/official\""
        echo "en_user = \"i18n/en/user\""
        echo "pl_experimental = \"i18n/pl/experimental\""
        echo "pl_official = \"i18n/pl/official\""
        echo "pl_user = \"i18n/pl/user\""
    } >> "$TMP_FILE"

    mv "$TMP_FILE" "$TARGET"
    echo -e "{{clr_success}}✅ Gotowe! Zapisano w: am_config/ambero_paths.toml{{style_reset}}"
    just _dir-view-logic

[no-cd]
_dir-view-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"

    if test ! -f "$TARGET"; then echo -e "{{clr_error}}❌ Błąd: Brak pliku!{{style_reset}}"; exit 1; fi

    # [ZMIANA] Tytuł i ramka są teraz stałym elementem widoku
    echo -e "\n📂 STRUKTURA ŚCIEŻEK FRAMEWORKU AMBERO:\n=================================================="

    LAST_LANG=""
    while IFS= read -r line || [ -n "$line" ]; do
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$(echo "$line" | tr -d '[:space:]')" ]] && continue

        # Sekcje (SYSTEM, INSTALL itd.)
        if [[ "$line" =~ ^\[.*\]$ ]]; then
            section=$(echo "$line" | tr -d "[]" | tr "[:lower:]" "[:upper:]")
            case "$section" in
                SYSTEM) ICON="🖥️ " ;; INSTALL) ICON="📦 " ;; JUST) ICON="⚙️ " ;;
                PLUGINS) ICON="🔌 " ;; I18N) ICON="🌐 " ;; *) ICON="🔷 " ;;
            esac
            echo -e "\n${ICON}SEKCJA: $section\n--------------------------------------------------"
            LAST_LANG=""

        # Klucze i wartości (Zawsze pełne drzewo)
        elif [[ "$line" =~ = ]]; then
            key=$(echo "$line" | cut -d"=" -f1 | tr -d " "); val=$(echo "$line" | cut -d"=" -f2- | tr -d "\"")

            if [[ "$val" =~ ^i18n/([a-z]{2})/(.*) ]]; then
                CUR_LANG="${BASH_REMATCH[1]}"; SUB_PATH="${BASH_REMATCH[2]}"
                if [ "$CUR_LANG" != "$LAST_LANG" ]; then
                    printf "  ├── 🌎 JĘZYK: \x1b[1;35m%s\x1b[0m\n" "$CUR_LANG"
                    LAST_LANG="$CUR_LANG"
                fi
                printf "  │   └── \x1b[36m%-16s\x1b[0m ➡️   \x1b[32m%s\x1b[0m\n" "$key" "$SUB_PATH"

            elif [[ "$key" =~ ^(root|core|config|logs)$ ]]; then
                printf "  ├── \x1b[36m%-20s\x1b[0m ➡️   \x1b[32m%s\x1b[0m\n" "$key" "$val"

            else
                printf "  │   └── \x1b[36m%-16s\x1b[0m ➡️   \x1b[32m%s\x1b[0m\n" "$key" "$val"
            fi
        fi
    done < "$TARGET"

    echo -e "==================================================\n"
    exit 0
