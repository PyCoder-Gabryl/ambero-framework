# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Silnik komunikatów UI (Message Engine).
#                   Odpowiada za warunkowe drukowanie treści i ramek.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/ui_msg.just
# VERSION:         0.1.0
# CREATED:         2026-07-22
# ============================================================================
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# ============================================================================
# SEKCJA: UNIWERSALNY PRZEKAŹNIK KOMUNIKATÓW
# ============================================================================

# Drukuje linię tekstu, jeśli aktualna waga jest wystarczająca
# Argumenty: weight (0-4), message
@_ui-msg weight message:
    @#!/usr/bin/env bash \
    CURRENT_W=${AMBERO_VERBOSITY_WEIGHT:-2}; \
    if [ "$CURRENT_W" -ge "{{weight}}" ]; then \
        PREFIX=""; \
        if [ "$CURRENT_W" -ge 2 ]; then PREFIX="{{clr_amber}}│{{style_reset}} "; fi; \
        echo -e "${PREFIX}{{message}}"; \
    fi

# ============================================================================
# SEKCJA: BLOKI SPECJALNE (EDU & LOG)
# ============================================================================

# Wyświetla sformatowany blok edukacyjny (tylko dla trybu edu+)
@_ui-edu-block content:
    @#!/usr/bin/env bash \
    CURRENT_W=${AMBERO_VERBOSITY_WEIGHT:-2}; \
    if [ "$CURRENT_W" -ge 3 ]; then \
        echo -e "\n{{clr_cyan}}{{style_bold}}🎓 EDU:{{style_reset}}"; \
        echo -e "{{content}}" | sed 's/^/{{clr_cyan}}│{{style_reset}} /'; \
        echo -e ""; \
    fi

# ============================================================================
# KOMENTARZ EDUKACYJNY (UI DESIGN)
# ============================================================================
# [EDU] 1. System "otwartych ramek" polega na dodawaniu przedrostka '│ '
#          tylko w trybach prod i wyższych. W quiet/minimal tekst jest surowy.
# [EDU] 2. Użycie 'sed' w bloku EDU pozwala na automatyczne dodanie ramki
#          do każdej linii wielowierszowego opisu (automatyzacja formatowania).
# [EDU] 3. Zmienna AMBERO_VERBOSITY_WEIGHT jest sercem filtrowania treści.
