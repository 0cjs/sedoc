Windows Notes
=============


File and Directory Links
------------------------

[NTFS links] are of three types:
- Hard links, for files only, which have files share the same MFT entry
  (inode), in the same filesystem.
- Junction points, which are similar to hard links, but defined for folders
  and can be only local, absolute paths.
- [Symbolic Links][gfw sym], which are not widely available and still not
  understood by many programs. Note that `ln -s` in Git Bash creates
  copies, not symbolic links.

Windows also uses [shortcut files][.lnk] (also known as "shell links");
these are regular files ending in `.lnk`, `.url` and `.cda`. These are
parsed by Windows Explorer, not the OS, and are not transparent to
applications.

The `mklink` command below is an internal `CMD.exe` and cannot be used in
Git Bash. `fsutil.exe` does work from Git Bash and offers `hardlink` and
`reparsePoint` subcommands that provide similar functionality.

### Hard Links

    fsutil hardlink create LINKNAME TARGET
    fsutil hardlink list TARGET
    mklink /h LINKNAME TARGET

### Junction Points

    fsutil reparsePoint ???         # XXX fill this in
    mklink /j linkname target

### Symlinks

[Symbolic Links][gfw sym] have separate types for file and directory
targets. Directory links are created with `mklink /d linkname target`; drop
the `/d` option for files.

The `SeCreateSymbolicLinkPriv` privilege required; only admins have it by
default (it can be assigned to other users and groups) and it's guarded by
UAC. It can be added with `gpedit.msc`: Computer Configuration » Window
Settings » Security Settings » Local Policies » User Rights Assignment,
Create Symbolic Links list. (Also `secpol.msc` to start in the middle
above, or downloaded `polseditx64.exe` on Home editions.)



<!-------------------------------------------------------------------->
[NTFS links]: https://en.wikipedia.org/wiki/NTFS_links
[gfw sym]: https://github.com/git-for-windows/git/wiki/Symbolic-Links
[.lnk]: https://en.wikipedia.org/wiki/Shortcut_(computing)#Microsoft_Windows
