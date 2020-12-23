Electronic Engineering Info
===========================

Also see [to-do list](todo.md)

E Series
--------

    40% E3   10              22              47
    20% E6   10      15      22      33      47      68
    10% E12  10  12  15  18  22  27  33  39  47  56  68  82
     5% E24    11  13  16  20  24  30  36  43  51  62  75  91


Markup
------

Most characters discussed here are given with the Unicode code point,
character and Vim digraph.

Standard chars used here:
- U+0305 `◌̅` `'/` overbar (NOT); vim digraph is cjs config
- U+0047 `/`  `  ` slash (NOT)
- U+0043 `+`  `  ` plus (OR)
- U+2219 `∙`  `Sb` bullet operator (AND)
- U+2295 `⊕`  `0+` circled plus (XOR); vim digraph is cjs config
- U+2260 `≠`  `!=` not equal to

Other logic characters I've considered:
- U+203E `‾ '-` [overline]
- U+2218 `∘ Ob` ring operator
- U+00AC `¬ NO` logical NOT
- U+2022 `• .m` bullet
- U+00b7 `· .M` middle dot (latin 1)
- U+2227 `∧ AN` logical and
- U+2228 `∨ OR` logical or
- U+22BB `⊻   ` logical xor

The [Unicode Mathematical Operators block][ucmath] has more ideas.

Electronics symbols:
- U+23DA `⏚` earth ground
- U+238D `⎍` monostable symbol
- U+238E `⎎` hysteresis symbol

### "NOT" Signals

An active-low signal is normally indicated with bar or [overline]
\(not be confused with the shorter macron U+00AF `¯ 'm`). The
combining character U+305, "◌̅" or `&#773`, (`'/` digraph in cjs Vim
config) seems to work mostly ok:
- No problem on all Unix and mobile browsers I've tried.
- GitHub markdown is fine in normal text but for code quotes only
  shifts the bar to the right: `C̅S̅`. If it's often viewed there you
  might prefix an overlined space: ` ̅C̅S̅`.
- `xterm` and `urxvt` are fine. MinGW (Git for Windows) terminal poor
  rendering with most fonts, unreadable with FixedSys.
- Stack Exchange: see [rtm-overbar].

Non-combining macron characters aren't really useful because the are
not complete, restricted mainly to vowels, so we have U+0100 `Ā A-`
but not `‾B`.

Various options that were considered before settling on the first two
(depending on situation):

| Text | Code   | Description
|------|--------|------------------------------------------------------
| C̅S̅   | ` C̅S̅`  | combining overbar
| /CS  | `/CS`  | leading slash
| ¬CS  | `¬CS`  | leading NOT symbool
|  CSB | ` CSB` | trailing B (for "bar") as used in MOS documentation
| ‾CS  | `‾CS`  | leading overbar
| ¯CS  | `¯CS`  | leading macron
|  CS' | ` CS'` | mainly used in ASCII boolean algebra?

#### Overline Markup

Overline markup in other areas:
- Unicode Combining Overline U+0305: a̅ `a&#773;`
  - Displays properly in Vim!
  - Allegedly doesn't work in some browsers, though works all I've tried.
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
[rtm-overbar]: https://retrocomputing.meta.stackexchange.com/a/662/7208
