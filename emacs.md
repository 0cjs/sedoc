Emacs Basics
============

#### Basic Movement

* `C-x; M-x`: Control-x; Alt-x or ESC-x
* `C-b,f`, `M-b,f`, `C-M-b,f`: back/fwd char; word; S-exp (matching paren/quote/etc.)
* `C-M-u,d`: up (out of), down (into) S-exp
* `C-p,n`: prev/next line
* `C-a,e`, `M-a,e`, `C-up,down`: beg,end of line, sentence, paragraph
* `M,C-v`: back/fwd scroll (PgUp/PgDn)
* `C-M-v`: forward scroll in other window
* `M-<,>`: beg,end of buffer
* `M-g g`: Jump to line
* `C-r,s`, `C-M-s`: back,forward search; regexp search
* `C-s C-s`: repeat search

#### Count Prefix

Count prefixes (the _numeric argument_) work like vi (# is a numeric digit):
* `C-#`, `M-#` or `C-M-#`
* `C-u #`
* `C-u`, `C-u C-u`, etc.: 4, 4² (16), 4³ (64), etc.

#### More

* XXX Add more here from Mastering Emacs: [Effective Editing I: Movement][me-ee1].

#### Further References

* [Princeton CS126 Emacs Quick Reference](https://www.cs.princeton.edu/courses/archive/spr97/cs126/help/emacs.html)
* Gnu.org: [A Guided Tour of Emacs](https://www.gnu.org/software/emacs/tour/)
* Mastering Emacs: [Effective Editing I: Movement][me-ee1m]:
  (A _very_ good intro, esp. for Vim users used to sophisticated movement.)

[me-ee1]: https://www.masteringemacs.org/article/effective-editing-movement
