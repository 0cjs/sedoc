Windows Notes
=============

Bash vs. CMD
------------

Certain commands, such as `mklink`, are internal to the `cmd` command and
thus can't be called from MINGW Bash. To run these:
- `cmd //c mklink` to run a single command
- `cmd` to start a Command Prompt in the current window, do your stuff,
  and type `exit` to return.
- `winpty` is not needed here for some reason and does not work.


File and Directory Links
------------------------

[NTFS links] are of three types:
- __Hard links__ for files only, which have files share the same MFT entry
  (inode), in the same filesystem. These are very similar to Unix hard
  links.
- __Junction points__ which are special files that can contain redirects to
  other directories on the machine, amongst other information. The target
  path must be absolute, but can be on any local drive. The File Manager
  icon is a folder icon with a small arrow at the lower left; in MINGW Bash
  these are shown as and act like Unix symlinks.
- [__Symbolic Links__][gfw sym], which are not widely available and still
  not understood by many programs. Note that `ln -s` in Git Bash creates
  copies, not symbolic links.

Windows also uses [shortcut files][.lnk] (also known as "shell links");
these are regular files ending in `.lnk`, `.url` and `.cda`. These are
parsed by Windows Explorer, not the OS, and are not transparent to
applications.

The `mklink` command below is an internal `CMD.exe` and cannot be used in
Git Bash (but see above). `fsutil.exe` does work from Git Bash and offers
`hardlink` and `reparsePoint` subcommands that provide similar functionality.

### Hard Links

    fsutil hardlink create LINKNAME TARGET
    fsutil hardlink list TARGET
    mklink /h LINKNAME TARGET

### Junction Points

    mklink /j linkname target
    fsutil reparsePoint query PATH
    fsutil reparsePoint delete PATH

Note that reparse points are used for much more than just directory
junctions. They can include arbitrary information for various file system
filters. The `fsutil reparsePoint query` command will show all the tags
within the junction point file and their interpreted and raw data.

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
