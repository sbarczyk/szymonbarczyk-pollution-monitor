# PollutionDB Monitor

Aplikacja webowa do monitorowania stacji pomiaru zanieczyszczeń środowiskowych.  
Projekt zrealizowany na potrzeby przedmiotu **Programowanie w językach Erlang/Elixir**.

## Autor

**Szymon Barczyk**

## Opis

Aplikacja umożliwia:
- Zarządzanie stacjami pomiarowymi (dodawanie, wyświetlanie listy, filtrowanie po lokalizacji).
- Dodawanie nowych odczytów pomiarów dla stacji.
- Wyszukiwanie oraz filtrowanie odczytów według daty.
- Prosty i przejrzysty interfejs webowy zbudowany w oparciu o Phoenix LiveView.
- Nawigację między poszczególnymi widokami aplikacji.

## Uruchomienie

Aby uruchomić serwer Phoenix:

1. Zainstaluj zależności i skonfiguruj bazę danych:

    ```bash
    mix setup
    ```

2. Uruchom serwer Phoenix:

    ```bash
    mix phx.server
    ```

   lub w trybie IEx:

    ```bash
    iex -S mix phx.server
    ```

3. Otwórz aplikację w przeglądarce pod adresem: [http://localhost:4000](http://localhost:4000)

## Technologie

- Elixir
- Phoenix Framework (LiveView)
- TailwindCSS (podstawowe stylowanie)

## Uwagi

Projekt został zrealizowany w celach edukacyjnych.
