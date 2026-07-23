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
# VERSION:         0.3.0
# CREATED:         2026-07-20
# ============================================================================


# Wyswietla zawartosc rejestru wtyczek czytelnie i kolorowo ze stronicowaniem
plugin-show:
    @just _run-just "_plugin-show-logic" "plugin-show"

[private]
[no-cd]
_plugin-show-logic:
    #!/usr/bin/env bash
    set -euo pipefail

    # Definicja sciezki do automatycznie generowanego rejestru
    TARGET="{{AMBERO_DIR}}/am_plugins/plugins.just"

    # --- WERYFIKACJA ISTNIENIA PLIKU ---
    if test ! -f "$TARGET"; then
        echo -e "{{clr_error}}❌ Blad: Plik rejestru wtyczek nie istnieje!{{style_reset}}"
        echo -e "👉 Uruchom najpierw: {{clr_success}}just refresh-plugins{{style_reset}}"
        exit 1
    fi

    # --- SILNIK RENDERUJACY (STYLOWANIE W LOCIE) ---
    # Uruchamiamy podpowloke, ktorej wynik zostanie przekazany do procesora 'less'
    (
        echo -e "{{clr_b_cyan}}📄 PODGLAD REJESTRU WTYCZEK AMBERO{{style_reset}}"
        echo -e "{{clr_info}}📁 Sciezka: $TARGET{{style_reset}}"
        echo -e "{{clr_warn}}💡 Podpowiedz: Przewijaj strzalkami | Wyjscie klawiszem Q{{style_reset}}"
        echo "============================================================================"

        # Iteracja linia po linii z zachowaniem spacji i pustych wierszy
        while IFS= read -r line || [ -n "$line" ]; do

            # 1. Kolorowanie glownych naglowkow sekcji (linie zaczynajace sie od # ===)
            if [[ "$line" =~ ^#[[:space:]]*=== ]]; then
                echo -e "{{clr_b_blue}}$line{{style_reset}}"

            # 2. Kolorowanie ostrzezen systemowych o autogeneracji
            elif [[ "$line" =~ ^#[[:space:]]*GENERATED || "$line" =~ ^#[[:space:]]*AUTOMATICALLY ]]; then
                echo -e "{{clr_b_blue}}$line{{style_reset}}"

            # 3. Kolorowanie komentarzy pomocniczych (HELP-INFO wyciagniete z Ambera)
            elif [[ "$line" =~ ^# ]]; then
                echo -e "{{clr_yellow}}$line{{style_reset}}"

            # 4. Kolorowanie nazw zadan Just (targety konczace sie dwukropkiem)
            elif [[ "$line" =~ : ]]; then
                echo -e "{{clr_b_green}}$line{{style_reset}}"

            # 5. Obsluga linii pustych (zachowanie struktury wizualnej)
            elif [ -z "$line" ]; then
                echo ""

            # 6. Kolorowanie komend wewnatrz zadan (linie z wcieciem)
            else
                echo -e "  {{clr_b_purple}}$line{{style_reset}}"
            fi
        done < "$TARGET"
        echo "============================================================================"
    ) | less -R -P "📖 Przegladanie rejestru wtyczek. Wyjscie klawiszem Q"

    # --- KOMUNIKAT PO ZAMKNIECIU PODGLADU ---
    printf "\n{{clr_info}}👋 Wyjscie z podgladu. Plik zrodlowy:{{style_reset}}\n"
    printf "{{clr_cyan}}👉 %s{{style_reset}}\n\n" "$TARGET"
