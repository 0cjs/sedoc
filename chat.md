Chat System Tips and Tricks
===========================

Multi-system Chat Clients
-------------------------

* *[Franz](http://meetfranz.com/)* (Win/Mac/Linux): Basically a wrapper around
  the web interfaces of the chat systems (this makes Hangouts kinda terrible).
  Best feature may be getting all notifications from one place.
  UI is not great. Doesn't do [Line](https://line.me).

[Gitter]
--------

The zoom level of the Gitter desktop client [can be changed][gitter-zoom].  
Bring up the console from menu `Gitter / Developer Tools` and enter:

    gui.Window.get().zoomLevel = -1.1;   // 0 is default zoom

[Gitter]: https://gitter.im/apps
[gitter-zoom]: https://gist.github.com/MadLittleMods/fd8cebe7e370a471b073
