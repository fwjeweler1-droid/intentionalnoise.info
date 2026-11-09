# IntentionalNoise.info — community and information site

**Current network checkpoint:** [IN-NET-2026-11-08-SYNC-01](https://github.com/fwjeweler1-droid/connect.intentionalnoise.info/blob/main/NETWORK_SYNC_CHECKPOINT_2026-11-08.md)  
**Machine-readable cross-repository record:** [network-sync.json](network-sync.json)

## Responsibilities

- About Intentional Noise and independent creator resources.
- [Published artist directory](https://intentionalnoise.info/artists.html) reads the approved public `artist_pages` records from the shared Connect Supabase backend.
- [IneedaGig](https://ineedagig.net/) is the canonical public booking and gig-request entry.
- Member signup, private profiles, media and authentication remain under [Connect](https://connect.intentionalnoise.info/auth.html).
- Public artist showcase pages live at [IntentionalNoise.band](https://intentionalnoise.band/artists.html).

**Synchronization rule:** Public artist-profile data is shared by source reference, not by copying records to this site. This repository deploys independently from the other websites. Public visibility requires explicit artist publication; private drafts are excluded.

**Acceptance state:** GitHub Pages build successful; live new-user four-site edit/publish/unpublish acceptance pending. Historical repository content remains tracked in Git.
