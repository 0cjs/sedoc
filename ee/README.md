Electronic Engineering Info
===========================

Markup
------

Most characters discussed here are given with the Unicode code point,
character and Vim digraph.

Standard chars used here:
- U+0047 `/   ` slash (NOT)
- U+0043 `+   ` plus (OR)
- U+2219 `∙ Sb` bullet operator (AND)
- U+2295 `⊕   ` circled plus (XOR)
- U+2260 `≠ !=` not equal to

Other characters I've considered:
- U+203E `‾ '-` [overline]
- U+2218 `∘ Ob` ring operator
- U+00AC `¬ NO` logical NOT
- U+2022 `• .m` bullet
- U+00b7 `· .M` middle dot (latin 1)
- U+2227 `∧ AN` logical and
- U+2228 `∨ OR` logical or
- U+22BB `⊻   ` logical xor

The [Unicode Mathematical Operators block][ucmath] has more ideas.

### "NOT" Signals

An active-low signal is normally indicated with bar or [overline]
\(not be confused with the shorter macron U+00AF `¯ 'm`), but the
combining character U+305 `B◌̅` doesn't combine in text-mode viewing.

Non-combining macron characters aren't really useful because the are
not complete, restricted mainly to vowels, so we have U+0100 `Ā A-`
but not `‾B`.

Options considered:

    /CS   leading slash
    ¬CS   leading NOT symbool
     CSB  trailing B (for "bar") as used in MOS documentation
    ‾CS   leading overbar
    ¯CS   leading macron
     CS'  mainly used in ASCII boolean algebra?

Overline markup in other areas:
- HTML: `<span style="text-decoration: overline">text</span>`
- LaTeX: `$\overline{\mbox{<text>}}$` (mbox overrides math-mode)
- Wikipedia: `{{overline|CS}}`.
- [EE StackExchange]: LaTeX ([SE allowed HTML] does not support styles):
  - `\$\small \overline{\text{CS}}\$`
  - `\$\small CS_{RAM}=\small A_{15}\cdot\overline{\small{A_{14}}}$`



[EE StackExchange]: https://electronics.stackexchange.com/
[SE allowed HTML]: https://meta.stackexchange.com/questions/1777/what-html-tags-are-allowed-on-stack-exchange-sites
[overline]: https://en.wikipedia.org/wiki/Overline
[ucmath]: https://unicode-table.com/en/blocks/mathematical-operators/
