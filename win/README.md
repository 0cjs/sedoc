Windows Notes
=============


Symlinks
--------

- No symlinks before Visa. Still not understood by many programs.
- Separate types for file and directory targets.
- Create w/ `mklink /d source target` (w/o `/d` for files).
- `SeCreateSymbolicLinkPriv` required, only admins have it by default
  (guarded by UAC). Can be assigend to other users/groups.
- Directory junctions (`mklink /j source target`) are a popular
  alternative.

Add priv with `gpedit.msc`: Computer Configuration » Window Settings »
Security Settings » Local Policies » User Rights Assignment, Create
Symbolic Links list. (Also `secpol.msc` to start in the middle above, or
downloaded `polseditx64.exe` on Home editions.)

For more, see git-for-windows wiki [Symbolic Links][gfw sym].



<!-------------------------------------------------------------------->
[gfw sym]: https://github.com/git-for-windows/git/wiki/Symbolic-Links
