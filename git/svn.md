Using Subversion Repos with Git
===============================

Subversion repositories do not have branches or tags; the repo is one big
tree from the root. The standard layout is to have a subdirectory `trunk/`
containing the main development branch of the code and, at the same level
`branches/` and `tags` subdirs containing copies of the code for a given
branch/tag. (A typical tag subdir is named `tags/project-1.2.3/`.)

To examine the entire repo, use

    svn checkout http://svn.project.com/svn/project/

or similar; the checkout will be placed into a `project/` subdirectory on
the local filesystem and `project/trunk/` will be the latest version. (Note
that this will give you only the latest trunk, branch heads and tags, not
every revision in the repo.)

A full checkout like this should be used when getting author information
from Subversion repos (see below).

git-svn Client
--------------

`git-svn` can natively access Subversion repositories.


Converting Subversion Repos to Git
----------------------------------

There are various means of doing this; the most common instructions are
found at:
- GitHub Docs, [Importing a Subversion repository][gh-svn-import]
- Stack Overflow, [How do I migrate an SVN repository with history to a new
  Git repository?][so 79165]

These instructions will, however, convert Subversion "tags" to branches.
See the "svn2git" section below for a (one hopes) better method.

### Author Information

Most conversion methods want an `authors.txt` file to convert Subversion
authors (just a short username) to Git `Author:` lines. `svn log -q` will
print a single line followed by a line of hyphens for each commit:

    r20 | bruce | 2022-04-03 04:44:38 +0900 (Sun, 03 Apr 2022)
    ------------------------------------------------------------------------

In a complete Subversion repo checkout (see above), use a script like one
of the following to generate an `authors.txt` with a list of names for
which you need to supply `Author:` lines:

    svn log -q \
      | awk -F '|' '/^r/ {gsub(/ /, "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' \
      | sort -u > users.txt

    svn log -q | grep -e '^r' \
      | awk 'BEGIN { FS = "|" } ; { print $2" = "$2 }' \
      | sed 's/^[ \t]*//' | sort | uniq > authors.txt

and then edit `authors.txt` to replace the names after `=` with the
full name and e-mail address of the committer.


svn2git
-------

`svn2git` package is in the standard set of Debian packages.

`svn2git` assumes that the default branch name in a new Git repo is `master`,
and the script will abort in the middle if this isn't the case. To work
around this, temporarily modify your `~/.gitconfig` with:

    git config --global init.defaultBranch master

`svn2git` takes the URL on the command line; remember to use the root of
the repo, without the trailing `trunk/`. Typically you will want to add
`-m` to produce `git-svn-id:` trailers in the commit messages, `--authors
FILE` to point to the `authors.txt` file you generated above, and perhaps
other options if the repo layout is non-standard. E.g.:

    svn2git -m --authors ../authors.txt http://svn.xi6.com/svn/disx4/



<!-------------------------------------------------------------------->
[gh-svn-import]: https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/importing-a-subversion-repository
[so 79165]: https://stackoverflow.com/q/79165/107294
