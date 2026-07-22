# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Moduł weryfikacji spójności konfiguracji (Sanity Check).
#                   Sprawdza obecność pliku TOML przed startem logiki.
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/check_config.just
# VERSION:         0.2.0
# CREATED:         2026-07-20
# ============================================================================


# --- KOMUNIKATY LOKALNE ---
msg_no_config := "⚠️  INFO: Brak pliku konfiguracji. Ambero użyje wartości domyślnych."

# ============================================================================
# SEKCJA: WALIDACJA ŚRODOWISKA
# ============================================================================

# Klauzula bezpieczeństwa: Weryfikuje obecność pliku konfiguracyjnego.
@_check_config:
    @if [ ! -f "{{CONFIG_FILE}}" ]; then \
        echo -e "{{clr_warn}}{{msg_no_config}}{{style_reset}}"; \
    fi

# ============================================================================
# KOMENTARZ EDUKACYJNY (JUST)
# ============================================================================
# [EDU] Zadanie wyciszone znakiem '@' i używające kontynuacji linii '\'
#       gwarantuje, że kod Bash nie wycieknie do terminala użytkownika.
