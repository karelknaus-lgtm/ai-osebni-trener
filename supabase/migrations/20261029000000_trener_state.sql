create table public.trener_state (
  code text primary key check (char_length(code) between 16 and 40),
  state jsonb not null,
  updated_at bigint not null default 0,
  saved_at timestamptz not null default now()
);
alter table public.trener_state enable row level security;
revoke all on public.trener_state from anon, authenticated;

create or replace function public.trener_load(p_code text)
returns jsonb
language sql
security definer
set search_path = ''
stable
as $$
  select jsonb_build_object('state', s.state, 'updated_at', s.updated_at)
  from public.trener_state s
  where s.code = p_code and char_length(p_code) >= 16;
$$;

create or replace function public.trener_save(p_code text, p_state jsonb, p_updated_at bigint)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_code is null or char_length(p_code) < 16 or char_length(p_code) > 40 then
    raise exception 'invalid code';
  end if;
  if pg_column_size(p_state) > 400000 then
    raise exception 'state too large';
  end if;
  insert into public.trener_state (code, state, updated_at, saved_at)
  values (p_code, p_state, p_updated_at, now())
  on conflict (code) do update
    set state = excluded.state, updated_at = excluded.updated_at, saved_at = now()
    where public.trener_state.updated_at <= excluded.updated_at;
end;
$$;

revoke all on function public.trener_load(text) from public;
revoke all on function public.trener_save(text, jsonb, bigint) from public;
grant execute on function public.trener_load(text) to anon, authenticated;
grant execute on function public.trener_save(text, jsonb, bigint) to anon, authenticated;
