# AI osebni trener

Spletna aplikacija v slovenščini: vprašalnik, tedenski načrt vadbe, jedilnik iz izdelkov iz Lidla, Mercatorja in Spara, AI trener, napredek ter priprava na fizični test za policijo ali Slovensko vojsko.

Aplikacija je ena datoteka, [index.html](index.html), objavljena na GitHub Pages.

## Zaledje (Supabase)

- **Računi:** prijava z e-pošto in geslom (Supabase Auth). Podatki vsakega računa so v tabeli `user_state`, do katere ima dostop samo lastnik; funkcija `delete_my_account` izbriše račun ([migracija](supabase/migrations/20261030000000_user_state.sql)). Prejšnja tabela `trener_state` s kodami ni več v uporabi.
- **AI trener:** Edge Function `trener` ([koda](supabase/functions/trener/index.ts)) kliče Claude API. Potrebuje skrivnost `ANTHROPIC_API_KEY` v nastavitvah projekta (Edge Functions → Secrets).
