# 🦖 Ambero Framework

**Ambero** to nowoczesny, skryptowy framework automatyzujący zadania systemowe i deweloperskie. Został zaprojektowany z myślą o systemach UNIX (macOS, Linux),
stawiając na bezpieczeństwo, szybkość i czytelną architekturę.

Framework opiera się na nowoczesnym stosie technologicznym:

* **[Just](https://just.systems/)** – jako szybki i intuicyjny router poleceń (Task Runner).
* **[Amber](https://amber-lang.com/)** – jako bezpieczny język logiki systemowej (kompilowany do Basha).

## 🏗 Architektura i Tryby Pracy

Ambero działa w architekturze dwupoziomowej, co pozwala na bezpieczne rozwijanie frameworku bez psucia wersji zainstalowanej w systemie.

1. **Tryb PROD (Polecenie `am`)**
   Wersja zainstalowana w systemie użytkownika (np. w `~/.local/share/ambero`). Używana do codziennej pracy w dowolnym katalogu na dysku.
2. **Tryb DEV (Polecenie `ambero`)**
   Wersja deweloperska. Alias ten wskazuje bezpośrednio na kod źródłowy w Twoim IDE. Pozwala na testowanie nowych funkcji w locie, zanim zostaną one
   zainstalowane w systemie.

## 🚀 Jak używać poleceń?

Wszystkie polecenia wywołujemy poprzez główny alias, podając nazwę modułu lub zadania.

Wyświetlenie listy wszystkich dostępnych poleceń:

```bash
am
# lub w trybie deweloperskim:
ambero
```

## Uruchomienie konkretnego zadania

Przykład uruchomienia skryptu powitalnego:

```bash
am ambero
```

---

## 🛠 Wymagania systemowe

Aby **Ambero** mogło działać, system musi posiadać:

- System operacyjny **macOS** lub **Linux** (np. Debian).
- Zainstalowane narzędzie **just**.
- Zainstalowany interpreter **amber**.

> **Uwaga:** Oficjalny instalator Ambero potrafi automatycznie zainstalować powyższe zależności.

---

## 📜 Licencja

Projekt udostępniany jest na licencji **Apache License 2.0**.
