Project Jupyter and Python
==========================

[Jupyter] ([documentation]) is an ecosystem that grew out of IPython.
It uses _notebooks_ (JSON `.ipynb` files) containing cells with code,
text, etc. These are usually interpreted by the [web application], run
locally or remotely, for which _kernels_ provide interpreters for the
various languages used interactively in the notebook.

For notes on kernel creation see [Creating Language Kernels for
IPython][gibiansky], who created the [IHaskell] kernel.


Jupyter Hub
-----------

[Jupyter Hub] spawns, manages, and proxies multiple instances of the
single-user [Jupyter Notebook] server.

### Development Environments for Tutorials/Workshops

[Graham Dumpleton] provides a [series of blog posts][gd-jh] on how to
provide and administer development environments (e.g., for tutorials
and workshops), including terminal sessions, run in OpenShift. (This
is the [workshopper] tool.)
- [Using JupyterHub as a generic application spawner][gd-jh-1]
- [Running an interactive terminal in the browser][gd-jh-2]
- [Creating your own custom terminal image][gd-jh-3]
- [Deploying a multi user workshop environment][gd-jh-4]
- [Administration features of JupyterHub][gd-jh-5]
- [Dashboard combining workshop notes and terminal][gd-jh-6]
- [Integrating the workshop notes with the image][gd-jh-7]
- Deploying the full workshop
- ???



<!-- Jupyter -->
[IHaskell]: https://github.com/gibiansky/IHaskell
[Jupyter]: https://jupyter.org/
[documentation]: https://jupyter.org/documentation
[gibiansky]: http://andrew.gibiansky.com/blog/ipython/ipython-kernels/
[web application]: https://jupyter-notebook.readthedocs.io/en/stable/

<!-- Jupyter Hub -->
[Graham Dumpleton]: http://blog.dscpl.com.au
[Jupyter Hub]: https://jupyterhub.readthedocs.io
[Jupyter Notebook]: https://jupyter-notebook.readthedocs.io
[gd-jh-1]: http://blog.dscpl.com.au/2018/12/using-jupyterhub-as-generic-application.html
[gd-jh-2]: http://blog.dscpl.com.au/2018/12/running-interactive-terminal-in-browser.html
[gd-jh-3]: http://blog.dscpl.com.au/2018/12/creating-your-own-custom-terminal-image.html
[gd-jh-4]: http://blog.dscpl.com.au/2018/12/deploying-multi-user-workshop.html
[gd-jh-5]: http://blog.dscpl.com.au/2019/01/administration-features-of-jupyterhub.html
[gd-jh-6]: http://blog.dscpl.com.au/2019/01/dashboard-combining-workshop-notes-and.html
[gd-jh-7]: http://blog.dscpl.com.au/2019/01/integrating-workshop-notes-with-image.html
[gd-jh]: http://blog.dscpl.com.au/search/label/jupyterhub
[workshopper]: https://github.com/openshift-evangelists/workshopper
