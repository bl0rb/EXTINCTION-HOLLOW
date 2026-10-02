# Session-Statistik Extinction Hollow

Ausgewertet aus dem Protokoll der Claude-Code-Sitzung (27.09.–02.10.2026, eine Sitzung, Zeiten in UTC).

| Datei | Inhalt |
|---|---|
| session_stats.json | Gesamtsummen, Tage und Werkzeuge in einer Datei |
| daily.csv | pro Tag: Anfragen, Werkzeugaufrufe, Tokens, eigene Nachrichten |
| hourly.csv | pro Stunde: Anfragen, Werkzeugaufrufe, Tokens |
| requests.csv | jede einzelne Modell-Anfrage mit Zeit, Modell und Tokens |
| tools.csv | wie oft welches Werkzeug benutzt wurde |

Token-Spalten: `input_tokens` = neue Eingabe, `output_tokens` = von Claude geschrieben, `cache_creation_input_tokens` = in den Cache geschrieben, `cache_read_input_tokens` = aus dem Cache gelesen (der günstigste Posten). Dollarbeträge sind nicht enthalten, weil das Protokoll keine Kosten speichert.
