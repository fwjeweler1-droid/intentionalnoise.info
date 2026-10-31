-- Intentional Noise Connect: private two-member messaging, Supabase Postgres
-- Run in Supabase SQL Editor after creating the project. Test before production.
create extension if not exists pgcrypto;
create table public.connect_profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null check (char_length(display_name) between 2 and 80),
 instrument text, genre text, area text, bio text,
 created_at timestamptz not null default now()
);
create table public.connect_blocks (
 blocker_id uuid not null references auth.users(id) on delete cascade,
 blocked_id uuid not null references auth.users(id) on delete cascade,
 created_at timestamptz not null default now(),
 primary key(blocker_id,blocked_id),
 check(blocker_id <> blocked_id)
);
create table public.connect_conversations (
 id uuid primary key default gen_random_uuid(),
 member_a uuid not null references auth.users(id) on delete cascade,
 member_b uuid not null references auth.users(id) on delete cascade,
 created_at timestamptz not null default now(),
 check(member_a < member_b),
 unique(member_a,member_b)
);
create table public.connect_messages (
 id uuid primary key default gen_random_uuid(),
 conversation_id uuid not null references public.connect_conversations(id) on delete cascade,
 sender_id uuid not null references auth.users(id) on delete cascade,
 body text not null check(char_length(btrim(body)) between 1 and 2000),
 created_at timestamptz not null default now()
);
create index connect_messages_thread_time on public.connect_messages(conversation_id,created_at desc);
create table public.connect_reports (
 id uuid primary key default gen_random_uuid(),
 reporter_id uuid not null references auth.users(id) on delete cascade,
 reported_id uuid not null references auth.users(id) on delete cascade,
 reason text not null check(char_length(reason) between 5 and 500),
 created_at timestamptz not null default now(),
 check(reporter_id <> reported_id)
);
create or replace function public.connect_is_participant(thread uuid)
returns boolean language sql stable security definer set search_path = ''
as $$ select exists(select 1 from public.connect_conversations c where c.id=thread and auth.uid() in (c.member_a,c.member_b)) $$;
revoke all on function public.connect_is_participant(uuid) from public;
grant execute on function public.connect_is_participant(uuid) to authenticated;
create or replace function public.connect_not_blocked(first_id uuid, second_id uuid)
returns boolean language sql stable security definer set search_path = ''
as $$ select not exists(select 1 from public.connect_blocks b where (b.blocker_id=first_id and b.blocked_id=second_id) or (b.blocker_id=second_id and b.blocked_id=first_id)) $$;
revoke all on function public.connect_not_blocked(uuid,uuid) from public;
grant execute on function public.connect_not_blocked(uuid,uuid) to authenticated;
alter table public.connect_profiles enable row level security;
alter table public.connect_blocks enable row level security;
alter table public.connect_conversations enable row level security;
alter table public.connect_messages enable row level security;
alter table public.connect_reports enable row level security;
create policy "Public profiles viewable" on public.connect_profiles for select to authenticated using(true);
create policy "Own profile insert" on public.connect_profiles for insert to authenticated with check(id=auth.uid());
create policy "Own profile edit" on public.connect_profiles for update to authenticated using(id=auth.uid()) with check(id=auth.uid());
create policy "Own blocks view" on public.connect_blocks for select to authenticated using(blocker_id=auth.uid());
create policy "Own blocks create" on public.connect_blocks for insert to authenticated with check(blocker_id=auth.uid());
create policy "Own blocks delete" on public.connect_blocks for delete to authenticated using(blocker_id=auth.uid());
create policy "Participant reads thread" on public.connect_conversations for select to authenticated using(auth.uid() in (member_a,member_b));
create policy "Participant starts thread" on public.connect_conversations for insert to authenticated with check(auth.uid() in (member_a,member_b) and public.connect_not_blocked(member_a,member_b));
create policy "Participant reads messages" on public.connect_messages for select to authenticated using(public.connect_is_participant(conversation_id));
create policy "Participant sends message" on public.connect_messages for insert to authenticated with check(
 sender_id=auth.uid() and public.connect_is_participant(conversation_id)
 and exists(select 1 from public.connect_conversations c where c.id=conversation_id and public.connect_not_blocked(c.member_a,c.member_b))
);
create policy "Member files report" on public.connect_reports for insert to authenticated with check(reporter_id=auth.uid());
-- Reports intentionally have no client-side SELECT policy. Moderators use a separate privileged backend.
-- Before launch: enforce first-contact quotas server-side, CAPTCHA, moderation workflow and abuse auditing.
