# 📝 AMBERO - Lista zadań (TODO)

## 🎯 Kamień milowy 0.1.0 (MVP) - W TOKU

- [ ] Implementacja `am_install/install.sh` (Silnik instalacji)
- [ ] Implementacja `am_core/config_parser.ab` (Serce konfiguracji)
- [ ] Implementacja `am_core/ui.ab` (Kolory i ikony)
- [ ] Pierwszy plugin `core/hello` (Test działania)

## 🚀 Rozwój architektury (0.2.0+)

- [ ] **System i18n**: Budowa `i18n_engine.ab` i struktury katalogów tłumaczeń.
- [ ] **Plugin Discovery**: Skrypt automatycznie generujący `am_plugins/plugins.just`.
- [ ] **User Plugins**: Obsługa katalogu `am_user_plugins` i izolacja od oficjalnego kodu.
- [ ] **Experimental Mode**: Przełącznik w configu dla pluginów w fazie testów.

## 🛠 Narzędzia i Narzędzia pomocnicze

- [ ] **Ambero Browser**: Kolorowa przeglądarka pluginów oparta na `fzf`.
- [ ] **Custom Logger**: Moduł Amber do zapisu logów frameworka do `logs/`.
- [ ] **Plugin Manager**: Komendy `am plugin-add` / `am plugin-remove`.
- [ ] **Health Check**: Zadanie `am doctor` sprawdzające spójność wszystkich zainstalowanych pluginów.

## 🧪 Inne

- [ ] Obsługa archiwów `.tar.gz` i `.tgz` w instalatorze.
- [ ] Automatyczna migracja `config.toml` przy aktualizacjach (dodawanie nowych kluczy).
