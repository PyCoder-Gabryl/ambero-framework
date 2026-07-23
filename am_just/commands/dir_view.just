# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Generator mapy ścieżek frameworku. Odpowiada za
#                   tworzenie i aktualizację pliku ambero_paths.toml.
#                   Wersja 0.3.5: Pełna obsługa trybów Q/MIN oraz sekcji EDU/DEV.
# ----------------------------------------------------------------------------
# PATH:            am_just/commands/dir_view.just
# VERSION:         0.3.5
# CREATED:         2026-07-20
# ============================================================================

# Generuje lub aktualizuje plik konfiguracyjny ze ścieżkami
map-paths:
    @just _run-just "_map-paths-logic" "map-paths"

# Drukuje zmapowane sekcje i ścieżki w czytelny sposób
dir-view:
    @just _run-just "_dir-view-logic" "dir-view"

# [EDU] Wyjaśnienie roli mapowania ścieżek
@_dir-view-logic-edu:
    @just _ui-edu-block "Plik ambero_paths.toml to 'mapa drogowa' systemu.\n\
        │   Pozwala on na uniknięcie sztywnych ścieżek w kodzie Amber.\n\
        │   Dzięki temu wtyczki mogą być przenoszone między folderami\n\
        │   bez konieczności zmiany logiki skryptów. Każdy moduł Ambero\n\
        │   importuje 'am_core/path.ab', aby poznać swoje otoczenie."

# [DEV] Diagnostyka ścieżek (v0.3.5: kolory i ścieżka pliku)
@_dir-view-logic-dev:
    @echo -e "{{clr_amber}}│{{style_reset}} {{clr_b_red}}DEBUG:{{style_reset}} {{clr_yellow}}Lokalizacja pliku ścieżek:{{style_reset}}"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📂 {{AMBERO_DIR}}/am_config/ambero_paths.toml"; \
    echo -e "{{clr_amber}}│{{style_reset}} 🛠️  Generator: am_just/commands/dir_view.just [dir-view]"; \
    echo -e "{{clr_amber}}│{{style_reset}} 📄 Plik zadania: am_just/commands/dir_view.just"

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
    printf "\n[system]\ncore = \"am_core\"\nconfig = \"am_config\"\nlogs = \"logs\"\n" >> "$TMP_FILE"
    printf "\n[install]\nroot = \"am_install\"\nplatforms = \"am_install/lib/platforms\"\n" >> "$TMP_FILE"
    printf "\n[just]\nroot = \"am_just\"\ncommands = \"am_just/commands\"\nlib = \"am_just/lib\"\n" >> "$TMP_FILE"
    printf "\n[plugins]\nroot = \"am_plugins\"\nexperimental = \"am_plugins/experimental\"\n" >> "$TMP_FILE"
    printf "official = \"am_plugins/official\"\nuser = \"am_plugins/user\"\n" >> "$TMP_FILE"
    printf "\n[i18n]\nroot = \"i18n\"\nen_experimental = \"i18n/en/experimental\"\n" >> "$TMP_FILE"
    printf "en_official = \"i18n/en/official\"\nen_user = \"i18n/en/user\"\n" >> "$TMP_FILE"
    printf "pl_experimental = \"i18n/pl/experimental\"\npl_official = \"i18n/pl/official\"\n" >> "$TMP_FILE"
    printf "pl_user = \"i18n/pl/user\"\n" >> "$TMP_FILE"
    mv "$TMP_FILE" "$TARGET"
    echo -e "{{clr_success}}✅ Gotowe! Zapisano w: am_config/ambero_paths.toml{{style_reset}}"
    just _dir-view-logic

[no-cd]
_dir-view-logic:
    #!/usr/bin/env bash
    set -euo pipefail
    TARGET="{{AMBERO_DIR}}/am_config/ambero_paths.toml"
    W=${AMBERO_VERBOSITY_WEIGHT:-2}
    if test ! -f "$TARGET"; then echo -e "{{clr_error}}❌ Błąd: Brak pliku!{{style_reset}}"; exit 1; fi
    [ "$W" -ge 2 ] && echo -e "\n📂 STRUKTURA ŚCIEŻEK FRAMEWORKU AMBERO:\n=================================================="
    LAST_LANG=""
    while IFS= read -r line || [ -n "$line" ]; do
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$(echo "$line" | tr -d '[:space:]')" ]] && continue
        if [[ "$line" =~ ^\[.*\]$ ]]; then
            if [ "$W" -ge 2 ]; then
                section=$(echo "$line" | tr -d "[]" | tr "[:lower:]" "[:upper:]")
                case "$section" in
                    SYSTEM) ICON="🖥️ " ;; INSTALL) ICON="📦 " ;; JUST) ICON="⚙️ " ;;
                    PLUGINS) ICON="🔌 " ;; I18N) ICON="🌐 " ;; *) ICON="🔷 " ;;
                esac
                echo -e "\n${ICON}SEKCJA: $section\n--------------------------------------------------"
            fi
            LAST_LANG=""
        elif [[ "$line" =~ = ]]; then
            key=$(echo "$line" | cut -d"=" -f1 | tr -d " "); val=$(echo "$line" | cut -d"=" -f2- | tr -d "\"")
            if [[ "$val" =~ ^i18n/([a-z]{2})/(.*) ]]; then
                CUR_LANG="${BASH_REMATCH[1]}"; SUB_PATH="${BASH_REMATCH[2]}"
                if [ "$CUR_LANG" != "$LAST_LANG" ]; then
                    L_ICO=$( [ "$W" -ge 1 ] && echo "🌎 " || echo "" )
                    [ "$W" -ge 2 ] && printf "  ├── %sJĘZYK: \x1b[1;35m%s\x1b[0m\n" "$L_ICO" "$CUR_LANG"
                    LAST_LANG="$CUR_LANG"
                fi
                [ "$W" -ge 2 ] && printf "  │   └── \x1b[36m%-16s\x1b[0m ➡️   \x1b[32m%s\x1b[0m\n" "$key" "$SUB_PATH"
                [ "$W" -lt 2 ] && printf "%s%s.%s ➡️   %s\n" "$( [ "$W" -eq 1 ] && echo "🌎 " )" "$CUR_LANG" "$key" "$SUB_PATH"
            elif [[ "$key" =~ ^(root|core|config|logs)$ ]]; then
                [ "$W" -ge 2 ] && printf "  ├── \x1b[36m%-20s\x1b[0m ➡️   \x1b[32m%s\x1b[0m\n" "$key" "$val"
                [ "$W" -lt 2 ] && printf "%s%s ➡️   %s\n" "$( [ "$W" -eq 1 ] && echo "📦 " )" "$key" "$val"
            else
                [ "$W" -ge 2 ] && printf "  │   └── \x1b[36m%-16s\x1b[0m ➡️   \x1b[32m%s\x1b[0m\n" "$key" "$val"
                [ "$W" -lt 2 ] && printf "  └── %s ➡️   %s\n" "$key" "$val"
            fi
        fi
    done < "$TARGET"
    [ "$W" -ge 2 ] && echo -e "==================================================\n"
