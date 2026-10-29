# AI osebni trener

Spletna aplikacija v slovenščini: vprašalnik, tedenski načrt vadbe, jedilnik iz izdelkov iz Lidla, Mercatorja in Spara, AI trener, napredek ter priprava na fizični test za policijo ali Slovensko vojsko.

Aplikacija je ena datoteka, [index.html](index.html), objavljena na GitHub Pages.

## Zaledje (Supabase)

- **Baza:** tabela `trener_state` s funkcijama `trener_load` in `trener_save` ([migracija](supabase/migrations/20261029000000_trener_state.sql)). Vsak uporabnik dobi 16-mestno kodo, s katero odpre svoje podatke na drugi napravi.
- **AI trener:** Edge Function `trener` ([koda](supabase/functions/trener/index.ts)) kliče Claude API. Potrebuje skrivnost `ANTHROPIC_API_KEY` v nastavitvah projekta (Edge Functions → Secrets).
