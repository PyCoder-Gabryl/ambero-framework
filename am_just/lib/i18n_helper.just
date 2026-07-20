# ============================================================================
# PROJECT:         Ambero Framework CLI
# AUTHOR:          PyCoder Gabryl
# GITHUB:          https://github.com/PyCoder-Gabryl/
# EMAIL:           pycoder.gabryl@gmail.com
# LICENSE:         Apache 2.0
# ----------------------------------------------------------------------------
# DESCRIPTION:      Mostek i18n dla Justa (I18n Bridge).
# ----------------------------------------------------------------------------
# PATH:            am_just/lib/i18n_helper.just
# VERSION:         0.1.0
# CREATED:         2026-07-20
# ============================================================================
# !!! UWAGA: PLIK SYSTEMOWY - NIE EDYTUJ RĘCZNIE !!!
# !!! WARNING: SYSTEM FILE - DO NOT EDIT MANUALLY !!!
# ============================================================================

# Pobiera tłumaczenie klucza (używane wewnętrznie przez Just)
# Argumenty: p_type (official/user), target, key
@_tr p_type target key:
    @amber run {{AMBERO_DIR}}/am_core/i18n_engine.ab --get {{p_type}} {{target}} {{key}}
