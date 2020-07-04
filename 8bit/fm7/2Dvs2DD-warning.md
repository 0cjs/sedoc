Fujitsu FM77 2DD vs. 2D Warning Screen
=======================================

### Background

The [FM77 series](fm77.md) series used [Y-E Data YD-625][yd-600]
series 3.5" drives. (For more details, see [FM-7/77 Floppy Disk
Information](floppy.md).) The first machines (the FM-77 through the
FM77AV) came with 320KB 40-track drives, which were a direct
substitute for the FM-7's 5.25" 320KB 40-track drives and used the
same format.

With the introduction of the FM-77AV20 and FM-77AV40 they switched to
640KB 80-track 3.5" drives. These have no problem reading 40-track
diskettes but, perhaps due to a narrower head, data written to a
40-track diskette on the 80-track drive is difficult to read on
40-track drives. (In my experience, using a diskette _formatted_ and
written on an 80-track drive, a 40-track drive can read a sector
without errors less than half the time; it may take a dozen or more
tries to read a small file, though usually it eventually can be read.)

### The Warning Notice

The 「FM-77AV20EX入門ディスク」(Introduction Disk) contains a set of
screens discussing handling and use of floppy diskettes, as described
in [a Japanese Vintage Computer Collection blog post][blog] by Sean.

One of the screens discusses compatibility between the new 640KB
drives and the older 320 KB 3.5" drives in previous models. Here's my
translation (with some help from friends). I try to stay fairly close
to the Japanese even where it makes the English a bit awkward. [Google
Translate][gtran] also produces a surprisingly good translation; you
may find it better or more readable than mine. translation that I do.

>        【Warning When Using the System Unit Internal Floppy Disk Drive】
>
> The FM77AV20EX system unit uses an internal floppy disk drive of 2DD
> type (double-sided double-density double-track type: 640KB).
>
> In the internal floppy drive you can read and write 2D type floppy
> disks (double-sided double-density type: 320KB) used with the FM-77
> and FM77AV. __However, a floppy disk, once written in the internal
> floppy disk drive, may become unreadable in a 2D-only type of
> floppy disk drive.__ Because of this, please take appropriate care.
>
> If possible, please use only 2DD type floppy disks in the FM77AV20EX


Here is the original text from an image in the blog post above, OCR'd
and corrected by me. (The OCR had a lot of errors due to the old 8-bit
display, so please let me know if there are any errors below.)

>         【本体内蔵のフロッピィディスクドライブ利用上の注意】
>
> FM77AV20EXの本体に内蔵されているフロッピィディスクドライブは、
> 2DDタイプ（両面倍密度倍トラックタイプ：640KB）用です。
>
> 内蔵のフロッピィディスクドライブではFM-77やFM77AVで
> 使用される2Dタイプのフロッピィディスク（両面倍密度タイプ：320KB）も
> 読み書きできます。 __ただし、内蔵のフロッピーディスクドライブで一度でも
> 書き込んだフロッピィディスクは本来の2Dタイプ専用の
> フロッピーディスクドライブでは読めなくなることがあります__ ので
> 十分注意してください。
>
> FM77AV20EXでは、できるだけ2DDタイプのフロッビィディスクを
> ご使用になるようを願いします。

Here is the original image, from [Sean's blog entry][blog]:

![][img]



<!-------------------------------------------------------------------->
[yd-600]: http://www.bitsavers.org/pdf/yeData/FDK-523002_YD-600_Specifications_Jan85.pdf
[blog]: https://monochromeeffect.org/JVCC/category/fujitsu-fm-77av20ex/applications-fujitsu-fm-77-av20ex/
[img]: https://monochromeeffect.org/JVCC/wp-content/uploads/2019/09/FM77AV20EX07-2048x1536.jpg
[gtran]: https://translate.google.com/#view=home&op=translate&sl=ja&tl=en&text=%E3%80%90%E6%9C%AC%E4%BD%93%E5%86%85%E8%94%B5%E3%81%AE%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%82%A3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E5%88%A9%E7%94%A8%E4%B8%8A%E3%81%AE%E6%B3%A8%E6%84%8F%E3%80%91%0A%0AFM77AV20EX%E3%81%AE%E6%9C%AC%E4%BD%93%E3%81%AB%E5%86%85%E8%94%B5%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%82%A3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E3%81%AF%E3%80%81%202DD%E3%82%BF%E3%82%A4%E3%83%97%EF%BC%88%E4%B8%A1%E9%9D%A2%E5%80%8D%E5%AF%86%E5%BA%A6%E5%80%8D%E3%83%88%E3%83%A9%E3%83%83%E3%82%AF%E3%82%BF%E3%82%A4%E3%83%97%EF%BC%9A640KB%EF%BC%89%E7%94%A8%E3%81%A7%E3%81%99%E3%80%82%0A%0A%E5%86%85%E8%94%B5%E3%81%AE%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%82%A3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E3%81%A7%E3%81%AFFM-77%E3%82%84FM77AV%E3%81%A7%20%E4%BD%BF%E7%94%A8%E3%81%95%E3%82%8C%E3%82%8B2D%E3%82%BF%E3%82%A4%E3%83%97%E3%81%AE%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%82%A3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%EF%BC%88%E4%B8%A1%E9%9D%A2%E5%80%8D%E5%AF%86%E5%BA%A6%E3%82%BF%E3%82%A4%E3%83%97%EF%BC%9A320KB%EF%BC%89%E3%82%82%20%E8%AA%AD%E3%81%BF%E6%9B%B8%E3%81%8D%E3%81%A7%E3%81%8D%E3%81%BE%E3%81%99%E3%80%82%20%E3%81%9F%E3%81%A0%E3%81%97%E3%80%81%E5%86%85%E8%94%B5%E3%81%AE%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%83%BC%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E3%81%A7%E4%B8%80%E5%BA%A6%E3%81%A7%E3%82%82%20%E6%9B%B8%E3%81%8D%E8%BE%BC%E3%82%93%E3%81%A0%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%82%A3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%81%AF%E6%9C%AC%E6%9D%A5%E3%81%AE2D%E3%82%BF%E3%82%A4%E3%83%97%E5%B0%82%E7%94%A8%E3%81%AE%20%E3%83%95%E3%83%AD%E3%83%83%E3%83%94%E3%83%BC%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E3%81%A7%E3%81%AF%E8%AA%AD%E3%82%81%E3%81%AA%E3%81%8F%E3%81%AA%E3%82%8B%E3%81%93%E3%81%A8%E3%81%8C%E3%81%82%E3%82%8A%E3%81%BE%E3%81%99%20%E3%81%AE%E3%81%A7%20%E5%8D%81%E5%88%86%E6%B3%A8%E6%84%8F%E3%81%97%E3%81%A6%E3%81%8F%E3%81%A0%E3%81%95%E3%81%84%E3%80%82%0A%0AFM77AV20EX%E3%81%A7%E3%81%AF%E3%80%81%E3%81%A7%E3%81%8D%E3%82%8B%E3%81%A0%E3%81%912DD%E3%82%BF%E3%82%A4%E3%83%97%E3%81%AE%E3%83%95%E3%83%AD%E3%83%83%E3%83%93%E3%82%A3%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%82%92%20%E3%81%94%E4%BD%BF%E7%94%A8%E3%81%AB%E3%81%AA%E3%82%8B%E3%82%88%E3%81%86%E3%82%92%E9%A1%98%E3%81%84%E3%81%97%E3%81%BE%E3%81%99%E3%80%82
