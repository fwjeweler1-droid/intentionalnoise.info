# Intentional Noise Connect — private messaging setup

Status: DEVELOPMENT ONLY. The public site remains unchanged.

## Supabase setup
1. Create a Supabase project controlled by Intentional Noise.
2. Enable email verification in Authentication; configure authorized site URL and redirect URLs.
3. In SQL Editor, review and apply `supabase/connect_messaging.sql`.
4. Set only the Supabase project URL and **publishable/anon key** in a future browser client. Never expose the service-role/secret key.
5. Create two **test** users, verify both email addresses, and create their profiles.
6. Test creating a conversation with sorted user UUIDs (member_a < member_b), sending and retrieving messages.
7. Verify a third authenticated test user cannot read the conversation or messages, including direct REST calls and altered UUIDs.
8. Verify a blocked member cannot create new conversations or send new messages.
9. Verify unauthenticated users cannot read messages and reports are not client-readable.

## Must complete before public launch
- Implement authenticated UI: sign-in, member profile, inbox, compose, reply, block and report.
- Enforce first-contact rate limits **server-side** (not only browser checks), CAPTCHA/abuse detection, reporting triage and account suspension.
- Review profile visibility and data minimization; define deletion/retention policy and privacy notice.
- Validate RLS with automated negative tests and separate test accounts. Review SECURITY DEFINER functions.
- Add monitoring, backups and clear community rules.
- Keep member-to-member messages free. Do not promise unlimited usage or uptime.

## Release gate
Do not merge this branch or accept real member messages until backend configuration and security tests pass.
