# Secure message delivery — not yet activated

The website forms are intentionally disabled until a secure submission endpoint exists. No visitor information is collected by the static site at this stage.

## Required setup
1. Deploy a server-side endpoint (for example a Cloudflare Worker) that accepts only HTTPS POSTs from the approved website origin, enforces rate limits, validates fields and spam honeypot, and returns clear success/failure status. CORS is not authentication; implement actual abuse controls.
2. Configure private durable submission storage (e.g., Cloudflare D1) with restricted access. Store timestamp, name, reply-to email, topic, message, marketing opt-in and consent version. Never put secrets or private records in GitHub.
3. Configure a verified transactional email provider for inbox notifications to the approved private business inbox. Keep the destination address as a server-side secret. Verify the sending domain/provider and deliverability.
4. Configure secure access, backups, deletion/export process, and an opt-out process for any future marketing list. Never automatically add non-opt-in contacts to marketing.
5. Test success, failure, spam, and mobile accessibility before enabling the form. Then put the deployed HTTPS endpoint into FORM_ENDPOINT in script.js and publish.

No form provider, email delivery, or storage has been provisioned by this package. A static GitHub Pages site cannot receive messages securely on its own.
