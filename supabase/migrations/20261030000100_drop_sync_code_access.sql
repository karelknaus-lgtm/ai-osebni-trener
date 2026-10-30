-- The anonymous sync-code functions are no longer used by the app.
revoke execute on function public.trener_load(text) from anon, public;
revoke execute on function public.trener_save(text, jsonb, bigint) from anon, public;
