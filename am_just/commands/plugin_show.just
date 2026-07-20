# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Przeglądarka rejestru wtyczek. Wyświetla zawartość
#                   pliku plugins.just w sposób sformatowany, kolorowy
#                   i stronicowany, ułatwiając inspekcję dostępnych zadań.
# ----------------------------------------------------------------------------
# PATH:            am_just/plugin_show.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================

# Wyświetla zawartość rejestru wtyczek czytelnie i kolorowo ze stronicowaniem
[no-cd]
plugin-show:
    #!/usr/bin/env bash
    set -euo pipefail

    TARGET="{{AMBERO_DIR}}/am_plugins/plugins.just"

    # --- WERYFIKACJA ISTNIENIA ---
    if test ! -f "$TARGET"; then
        echo -e "{{clr_error}}❌ Błąd: Plik rejestru wtyczek nie istnieje!{{style_reset}}"
        echo -e "👉 Uruchom najpierw: {{clr_success}}just refresh-plugins{{style_reset}}"
        exit 1
    fi

    # --- SILNIK RENDERUJĄCY (STYLOWANIE W LOCIE) ---
    # [EDU] Używamy podpowłoki (subshell), aby przekazać sformatowany tekst do 'less'.
    #       Flaga -R w 'less' jest kluczowa do poprawnej interpretacji kolorów ANSI.
    (
        echo -e "{{clr_b_cyan}}📄 PODGLĄD REJESTRU WTYCZEK AMBERO{{style_reset}}"
        echo -e "{{clr_info}}📁 Ścieżka: $TARGET{{style_reset}}"
        echo -e "{{clr_warn}}💡 Podpowiedź: Przewijaj strzałkami | Wyjście klawiszem Q{{style_reset}}"
        echo "============================================================================"

        while IFS= read -r line || [ -n "$line" ]; do
            # Kolorowanie nagłówków sekcji (ramki)
            if [[ "$line" =~ ^#[[:space:]]*=== ]]; then
                echo -e "{{clr_b_blue}}$line{{style_reset}}"
            # Kolorowanie ostrzeżeń o autogeneracji
            elif [[ "$line" =~ ^#[[:space:]]*GENERATED || "$line" =~ ^#[[:space:]]*AUTOMATICALLY ]]; then
                echo -e "{{clr_b_blue}}$line{{style_reset}}"
            # Kolorowanie zwykłych komentarzy (opisy HELP-INFO)
            elif [[ "$line" =~ ^# ]]; then
                echo -e "{{clr_yellow}}$line{{style_reset}}"
            # Kolorowanie nazw zadań (targetów)
            elif [[ "$line" =~ : ]]; then
                echo -e "{{clr_b_green}}$line{{style_reset}}"
            # Linie puste
            elif [ -z "$line" ]; then
                echo ""
            # Kolorowanie komend (linie z wcięciem)
            else
                echo -e "  {{clr_b_purple}}$line{{style_reset}}"
            fi
        done < "$TARGET"
        echo "============================================================================"
    ) | less -R -P "📖 Przeglądanie rejestru wtyczek. Wyjście klawiszem Q"

    # --- KOMUNIKAT PO WYJŚCIU ---
    printf "\n{{clr_info}}👋 Wyjście z podglądu. Plik źródłowy:{{style_reset}}\n"
    printf "{{clr_cyan}}👉 %s{{style_reset}}\n\n" "$TARGET"

# ============================================================================
# KOMENTARZ EDUKACYJNY (JUST & UI)
# ============================================================================
# [EDU] 1. 'less -R' pozwala na wyświetlanie surowych kodów ucieczki ANSI,
#          dzięki czemu stronicowany tekst zachowuje kolory.
# [EDU] 2. Pętla 'while read -r' z warunkiem '|| [ -n "$line" ]' gwarantuje,
#          że ostatnia linia pliku zostanie wczytana, nawet jeśli nie kończy
#          się znakiem nowej linii (częsty błąd przy autogeneracji).
# [EDU] 3. Zastosowanie aliasów kolorystycznych (np. clr_info) zapewnia
#          spójność wizualną z resztą frameworku.
