# =============================================================================
# MODUŁ: UTILS (NARZĘDZIA DEWELOPERSKIE)
# =============================================================================

# Tworzy kopię zapasową projektu w formacie .zip ignorując foldery tymczasowe i gita
backup:
    @mkdir -p "{{BACKUP_DIR}}"
    @TIMESTAMP=$(date +"%Y%m%d_%H%M%S"); \
    BACKUP_NAME="ambero_backup_${TIMESTAMP}.zip"; \
    echo "📦 Tworzenie kopii zapasowej ZIP frameworku Ambero..."; \
    cd "{{AMBERO_DIR}}" && zip -r "{{BACKUP_DIR}}/${BACKUP_NAME}" . -x "backups/*" ".git/*" ".idea/*" > /dev/null; \
    echo "✅ Kopia zapasowa ZIP zapisana pomyślnie!"
    @echo "📂 Lokalizacja: {{BACKUP_DIR}}/"
    @ls -lh "{{BACKUP_DIR}}" | tail -n 1
