KC85 Microsoft BASIC
====================

The screen is not editable; use `EDIT nnn` to bring up a full-screen editor
(the TEXT program) on a line. Adding additional lines will add new lines to
the program.

File management:
- BASIC has a "current workspace" which is either a `fname.BA` file or the
  unnamed workspace. Changes to the workspace immediately change the file.
  From the unnamed workspace you may `SAVE "fname"` to create a new named
  workspace; from a named workspace it will produce an `?FC Error` (illegal
  function call).
- `LOAD "fname"` will change the workspace to the given file.
- Selecting a program file from the menu and hitting Enter will set the
  workspace to that file and `RUN`, going to interpreter after break/exit.
- Selecting `BASIC` uses the unnamed workspace; this is preserved across
  runs of other selected programs.
- `SAVE "fname",A` will save a copy of the current program in ASCII format
  to `fname.DO`; the current workspace does not change.
- `LOAD "fname.xx"` when _xx_ is not a `.BA` file will wipe the current
  workspace, replacing it with the ASCII load.
- Use `KILL "fname.ex"` to remove a file. (`?FC Error` if it's current
  workspace.)
