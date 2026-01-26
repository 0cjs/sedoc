Google Drive Sync for Linux
===========================

Many GUI file manager apps support connecting to GDrive, including:
- OS-supplied: Nautilus. KDE Plasma. KIO GDrive (KDE).
  Gnome Online Accounts.
- Open source: GoSync (PyPI), CloudCross, Celeste (uses rclone), overGrive.
- Proprietary: Insync (paid).

Command-line clients:
- [rclone]. Linux/BSD/MacOS/Windows.
  - Supports more than 70 cloud storage projects.
  - `mount` command to mount FUSE filesystem
  - ? Daemon mode to background sync?
- [google-drive-ocamlfuse]: FUSE filesystem for GDrive
  - Source distro; ppa available for Ubuntu.
- [DriveSync]. Ruby. No longer maintained?
  - Replaces Google Drive client; does ul/dl/delete/etc.
  - Run manually or as a cronjob.
- odeke-em's [drive]. Go.
  - Small program to pull/push GDrive files.
- [grive2]
  - Downloads, syncs manually, uses `.trash` folder.
  - Fork of unmaintained "grive".

The best option of the above seems to be rclone; see [rclone](./rclone.md)
for a summary and more details.


rclone Google Drive Backend Driver
----------------------------------

When you need to, remove the third-party client authorization at
<https://myaccount.google.com/connections>.

### Backend Commands

In all cases, _REMOTE_ must be a Google Drive remote.

* `rclone backend help REMOTE:`: list all backend commands for Drive.

* [`rclone backend drives REMOTE: [opts] [args+]`][be-drives]: Display list
  of just Shared Drives (Team Drives) accessible to the client.
  - JSON format: list of dicts keyed `{ id:, kind:, name: }`. Kind is
    usually (always?) `drive#drive`.
  - `-o CONF` supposed to generate config with this info and `type =
    combine` entry for all drives together, but doesn't seem to work.

* [`rclone backend query REMOTE: QUERY`][be-query]: List files using Google
  Drive [search query terms and operators][gdql].

### Setting Up API Access Keys

By default rclone's client_id is used for API access; this is slow because
requests are rate limited for all users using it. For better speed, make
your own API key (see below). Note that the API key does not give you
access to any files and is completely independent of the authentication
tokens you use to get access to files.

Instructions are at [Making your own client_id][rc-mkGid]. This is a bit
complex; the following additional notes may help.

You'll want to set up a new project in the [Google API console][gapi-console].
(Suggested name: `myname-rclone-api-keys`.) Workspace users have a choice
of putting it in your Workspace domain (enabling Internal apps) or in
"uncategorized." To get back to the API console (and any other console in
Google Cloud services), it's best to click the ≡ menu, use the "View all
products" button at the very bottom, and pin the particular console you
want.

When configuring the OAuth Consent Screen, if you create an "Internal"
(instead of "External") app it avoids approval and/or scary messages. It
also immediately allows use by all users in the Workspace, rather than
having to add test users.

If you use an internal app, the "Google Auth Platform / Branding" page lets
you set the name that will appear as "NAME wants to access your Google
Account." To avoid confusion, set it to the Workspace name and project name
of your app, e.g., `mydomain.com myname-rclone-api-keys`.

When creating the OAuth client, keep a copy of the the client secret; it
cannot be retrieved after that client entry is created.

#### Rsync "Making your own client id" summary.

This summarises the rsync ["Making your own client"][rc-mkGid] instructions.

1. Log in to Google API console.
2. Select your `myname-rclone-api-keys` project using the picker at the top
   left. (Or create a project if you don't already have one; see above.)
3. Click the hamburger menu at the upper left and select the "Enabled APIs
   & services" console. (This can be marked as a favourite for easier
   access.)
4. Select "Google Drive API" from the list at the lower right. If not
   present, select "+ Enable APIs and services" at the the top, search for
   "Drive," select "Google Drive API" and click the "Enable" button, and
   then return to "APIs & Services".
5. Click "OAuth consent screen" at the left. If not configured, click "Get
   started" and configure per above or the [rsync web
   documentation][rc-mkGid].
6. Click "Audience." If you see "User type: internal" you need not add
   users (everyone in your Workspace is automatically added). Otherwise add
   yourself as a test user and press save.
7. Go to "Clients" (not "Overview" as the docs say) and create a client.
   Existing clients give enough information (`client_id` and last few chars
   of `client_secret`) to confirm correctness of existing `rclone.conf`
   entries.
8. … (XXX needs to be finished)

### Adding Remotes

Add a remote with `rclone config`, choosing `n`)ew remote then:
- name>: remote name
- Storage>: `drive`,
- client_id>:, client_secret>: OAuth client ID and secret from above.
  This is for Google API access, and will be under the `client_id` and
  `client_secret` entries in rclone.conf.
- scope>: Generally `drive` (or `1`) for full access.
- service_account_file>: Leave empty.
- "Use auto-config?"
  - `y` will immediately open up a browser window to authenticate to the
    Drive account (My Drive for an account or Shared Drive)
  - `n` will print links to authenticate later
  - Either way, this will generate the `token` entry in rclone.conf.
- "Configure this as a Shared Drive (Team Drive)?" If you type `y` it gives
  you a list of shared drives to which you have access, otherwise it uses
  your personal Drive. If a shared drive, it will set `team_drive` in
  rclone.conf.

You can then, e.g.:

    rclone lsl NAME:            # list all files (including subdirs)
    rclone copy NAME: ./name/   # clone the drive to the given subdir
    rclone copy ./name/ NAME:   # copy changed files back to Drive


<!-------------------------------------------------------------------->
[DriveSync]: https://github.com/MStadlmeier/drivesync
[drive]: https://github.com/odeke-em/drive
[google-drive-ocamlfuse]: https://github.com/astrada/google-drive-ocamlfuse
[rclone]: https://rclone.org/
[Grive2]: https://github.com/vitalif/grive2

<!-- Backend Commands -->
[be-drives]: https://rclone.org/drive/#drives
[be-query]: https://rclone.org/drive/#query
[gdql]: https://developers.google.com/workspace/drive/api/guides/ref-search-terms

<!-- Setting Up API Access Keys -->
[gapi-console]: https://console.developers.google.com/
[rc-mkGid]: https://rclone.org/drive/#making-your-own-client-id
