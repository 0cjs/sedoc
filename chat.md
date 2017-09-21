Chat System Tips and Tricks
===========================

Gitter
------

The zoom level of the Gitter desktop client [can be changed][gitter-zoom].  
Bring up the console from menu `Gitter / Developer Tools` and enter:

    var desktopWindow = gui.Window.get();
    desktopWindow.zoomLevel = -0.7;   // 0 is default zoom

[gitter-zoom]: https://gist.github.com/MadLittleMods/fd8cebe7e370a471b073
