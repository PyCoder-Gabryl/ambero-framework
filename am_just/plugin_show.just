# =============================================================================
# MODUŁ: UTILS (WIZUALIZACJA REJESTRU WTYCZEK)
# =============================================================================

# Wyświetla zawartość wygenerowanego pliku am_plugins/plugins.just czytelnie i kolorowo ze stronicowaniem
plugin-show:
	@bash -c ' \
	TARGET="{{AMBERO_DIR}}/am_plugins/plugins.just"; \
	if [ ! -f "$TARGET" ]; then \
		echo -e "{{clr_red}}❌ Błąd: Plik rejestru wtyczek nie istnieje!{{style_reset}}"; \
		echo -e "👉 Uruchom najpierw: {{clr_green}}just refresh-plugins{{style_reset}}"; \
		exit 1; \
	fi; \
	\
	( \
		echo -e "{{clr_b_cyan}}📄 PODGLĄD GENEROWANEGO PLIKU REJESTRU WTYCZEK:{{style_reset}}"; \
		echo -e "{{clr_cyan}}📁 Ścieżka: $TARGET{{style_reset}}"; \
		echo -e "{{clr_yellow}}💡 Podpowiedź: Przewijaj strzałkami | Wyjście klawiszem Q{{style_reset}}"; \
		echo "============================================================================"; \
		\
		while IFS= read -r line || [ -n "$line" ]; do \
			if [[ "$line" =~ ^#[[:space:]]*=== ]]; then \
				echo -e "{{clr_b_blue}}$line{{style_reset}}"; \
			elif [[ "$line" =~ ^#[[:space:]]*GENERATED || "$line" =~ ^#[[:space:]]*AUTOMATICALLY ]]; then \
				echo -e "{{clr_b_blue}}$line{{style_reset}}"; \
			elif [[ "$line" =~ ^# ]]; then \
				echo -e "{{clr_yellow}}$line{{style_reset}}"; \
			elif [[ "$line" =~ : ]]; then \
				echo -e "{{clr_b_green}}$line{{style_reset}}"; \
			elif [ -z "$line" ]; then \
				echo ""; \
			else \
				echo -e "  {{clr_b_purple}}$line{{style_reset}}"; \
			fi; \
		done < "$TARGET"; \
		echo "============================================================================"; \
	) | less -R -P "📖 Przeglądanie rejestru wtyczek. Przewijaj strzałkami | Wyjście klawiszem Q"; \
	\
	printf "\n{{clr_b_cyan}}👋 Wyjście z podglądu. Jeśli chcesz edytować plik ręcznie, znajdziesz go w:{{style_reset}}\n"; \
	printf "{{clr_cyan}}👉 %s{{style_reset}}\n\n" "$TARGET";'
