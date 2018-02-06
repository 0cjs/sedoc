Microsoft Visual Studio
=======================

Don't confuse [VS Code] with VS; the former is an open source,
multiplatform editor built on completely different technology from the
VS IDE.

Unix vs. DOS Newlines
---------------------

It can be very difficult to get VS to consistently use LFs only when
saving files. There's a 'consistent line endings' setting somewhere
that will handle existing files. Older VS versions have a __File »
Advanced Save Options » Unix Line Endings__ ([so-10611963], 2012, 43
votes) to set the mode for newly created files, but newer ones
apparently do not. New versions do have __Tools » Options... »
Environment » Documents » Check for consistent line endings on load__,
but this only deals with existing files and doesn't affect new files.

__Tools » Extensions and Updates__ apparently lets you search for
"line end" to find plugins that can help with this. Some recommended
on SO are:

* [Strip'em] ([so-1288642], 2009, 72 votes).
  Versions for VS through 2017. Source code available.
* 'Trim line ends on save,' also known as [IDCT.pl] ([so-29658845],
  2015, 6 votes). Trims tabs and spaces, and has settings for newlines.
  Not clear on what it does about new files. [Open source][idct-gh].


Build System
------------

Work is done in a single _solution_ which has zero or more _projects_
associated with it. (Projects may apparently be members of more than
one solution.) Projects each have their own set of configurations. A
solution configuration is the selected set of projects and a project
configuration for each project; a separate build is can be done for
each combination of solution configuration and platform. For more, see
[Understanding Build Configurations][vs-buildconf].

Under the hood, VS uses [MSBuild].

See also [so-1289356] (2009, 6 votes).



[IDCT.pl]: https://marketplace.visualstudio.com/items?itemName=IDCTpl.Trimlineendsonsave
[MSBuild]: https://en.wikipedia.org/wiki/MSBuild
[Strip'em]: http://www.grebulon.com/software/stripem.php
[VS Code]: https://code.visualstudio.com/
[idct-gh]: https://github.com/ideaconnect/vs-trim-line-ends-on-save-plugin
[so-10611963]: https://stackoverflow.com/a/10611963/107294
[so-1288642]: https://stackoverflow.com/a/1288642/107294
[so-1289356]: https://stackoverflow.com/a/1289356/107294
[so-29658845]: https://stackoverflow.com/a/29658845/107294
[vs-buildconf]: https://docs.microsoft.com/en-us/visualstudio/ide/understanding-build-configurations
