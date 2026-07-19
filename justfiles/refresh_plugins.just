# Automatycznie skanuje am_plugins i rejestruje dynamicznie wykryte pliki .ab
refresh-plugins:
	@echo "🔌 Odświeżanie i rejestracja wtyczek w systemie Ambero..."
	@bash -c ' \
	shopt -s nullglob; \
	OUT="{{AMBERO_DIR}}/am_plugins/plugins.just"; \
	echo "# ==========================================" > "$OUT"; \
	echo "# GENERATED AUTOMATICALLY - DO NOT EDIT" >> "$OUT"; \
	echo "# ==========================================" >> "$OUT"; \
	echo "" >> "$OUT"; \
	P_CNT=0; T_COUNT=0; \
	for t in official experimental user; do \
		DIR="{{AMBERO_DIR}}/am_plugins/$t"; \
		printf "\n{{clr_b_purple}}📂 [FOLDER TYPU]: am_plugins/%s{{style_reset}}\n" "$t"; \
		if [ ! -d "$DIR" ]; then \
			printf "  ⚠️  Katalog nie istnieje: %s\n" "$DIR"; \
			continue; \
		fi; \
		V_LIST=("$DIR"/*); \
		if [ ${#V_LIST[@]} -eq 0 ]; then \
			printf "  {{clr_yellow}}📂 (Katalog typów jest pusty){{style_reset}}\n"; \
		fi; \
		for v in "${V_LIST[@]}"; do \
			[ ! -d "$v" ] && continue; \
			v_nm=$(basename "$v"); \
			printf "  ├── 🏢 [SPRAWDZAM DOSTAWCĘ]: {{clr_b_blue}}%s{{style_reset}}\n" "$v_nm"; \
			F_LIST=("$v"/*.ab); \
			if [ ${#F_LIST[@]} -eq 0 ]; then \
				printf "  │            {{clr_yellow}}📂 (Katalog dostawcy jest pusty){{style_reset}}\n"; \
			fi; \
			for f in "${F_LIST[@]}"; do \
				[ ! -f "$f" ] && continue; \
				f_nm=$(basename "$f"); \
				if ! grep -q "main[[:space:]]*{" "$f"; then \
					printf "  │   ├── {{clr_yellow}}ℹ️  [NIE JEST WTYCZKĄ]: %s{{style_reset}}\n" "$f_nm"; \
					continue; \
				fi; \
				INFO=$(awk '\''BEGIN{IGNORECASE=1} /HELP-INFO/{sub(/^.*HELP-INFO[[:space:]]*:?[[:space:]]*/, ""); print; exit}'\'' "$f" | sed -E "s/^[[:space:]]*//; s/[[:space:]]*$//"); \
				if [[ "$f_nm" == *_test.ab ]]; then \
					raw_base="${f_nm%_test.ab}"; \
					base=$(echo "$raw_base" | tr "_" "-"); \
					[ -z "$INFO" ] && INFO="Test wtyczki: ${f_nm}"; \
					printf "  │   ├── 🧪 [WYKRYTO TEST]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s-test{{style_reset}}\n" "$f_nm" "$base"; \
					echo "# ${INFO}" >> "$OUT"; \
					echo "${base}-test: _check_config" >> "$OUT"; \
					echo "    @rm -rf {{AMBERO_DIR}}/am_plugins/$t/$v_nm/am_core" >> "$OUT"; \
					echo "    @ln -sfn {{AMBERO_DIR}}/am_core \\" >> "$OUT"; \
					echo "        {{AMBERO_DIR}}/am_plugins/$t/$v_nm/am_core" >> "$OUT"; \
					echo "    @amber run am_plugins/$t/$v_nm/$f_nm" >> "$OUT"; \
					echo "    @rm -rf {{AMBERO_DIR}}/am_plugins/$t/$v_nm/am_core" >> "$OUT"; \
					echo "" >> "$OUT"; \
					T_COUNT=$((T_COUNT + 1)); \
				else \
					raw_base="${f_nm%.ab}"; \
					base=$(echo "$raw_base" | tr "_" "-"); \
					[ -z "$INFO" ] && INFO="Wtyczka: ${f_nm}"; \
					printf "  │   ├── 🟢 [WYKRYTO PLIK]:   {{clr_cyan}}%-20s{{style_reset}} ➡️  {{clr_green}}%s{{style_reset}}\n" "$f_nm" "$base"; \
					echo "# ${INFO}" >> "$OUT"; \
					echo "${base}: _check_config" >> "$OUT"; \
					echo "    @rm -rf {{AMBERO_DIR}}/am_plugins/$t/$v_nm/am_core" >> "$OUT"; \
					echo "    @ln -sfn {{AMBERO_DIR}}/am_core \\" >> "$OUT"; \
					echo "        {{AMBERO_DIR}}/am_plugins/$t/$v_nm/am_core" >> "$OUT"; \
					echo "    @amber run am_plugins/$t/$v_nm/$f_nm" >> "$OUT"; \
					echo "    @rm -rf {{AMBERO_DIR}}/am_plugins/$t/$v_nm/am_core" >> "$OUT"; \
					echo "" >> "$OUT"; \
					P_CNT=$((P_CNT + 1)); \
				fi; \
			done; \
		done; \
	done; \
	echo "------------------------------------------------------------"; \
	echo "📊 PODSUMOWANIE REJESTRACJI:"; \
	printf "  • {{clr_b_green}}Wykryte wtyczki:{{style_reset}} %d\n" "$P_CNT"; \
	printf "  • {{clr_b_cyan}}Wykryte testy:{{style_reset}}   %d\n" "$T_COUNT"; \
	echo "------------------------------------------------------------"; \
	echo "✅ Gotowe! Wtyczki dopisane do am_plugins/plugins.just";'
