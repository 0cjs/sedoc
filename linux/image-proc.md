Linux Image Manipulation
========================

[DjVu]
------

The `ddjvu` tool can convert .djvu to other formats:P

    ddjvu --format=tiff page.djvu page.tiff
    ddjvu --format=pdf inputfile.djvu ouputfile.pdf
    # Export specific pages
    ddjvu --format=tiff --page=1-10 input.djvu output.tiff

[DjVu]: https://wiki.archlinux.org/index.php/Djvu#Convert_DjVu_to_images
