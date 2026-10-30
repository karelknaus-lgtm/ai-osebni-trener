-- App data per signed-in account (Supabase Auth). Replaces the anonymous sync-code table.
create table public.user_state (
  user_id uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  state jsonb not null,
  updated_at bigint not null default 0,
  saved_at timestamptz not null default now(),
  constraint user_state_size check (octet_length(state::text) < 1000000)
);

alter table public.user_state enable row level security;

create policy "own row: select" on public.user_state for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "own row: insert" on public.user_state for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "own row: update" on public.user_state for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

revoke all on public.user_state from anon, public;
grant select, insert, update on public.user_state to authenticated;

-- Lets a signed-in user delete their own account (Google Play requires in-app deletion).
-- The user_state row goes with it through the cascade.
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
