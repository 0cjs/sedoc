Text Format Codes
=================

#### Embedded URL Reformatting

Extract URLs from other URLs with

    sed -e 's,.*https%3A,https:,; s,%2F,/,g; s,%3F,?,g; s,%3D,=,g'


Markdown
--------

Though not exactly the original Markdown, commonmark.org provides a
[spec][cm spec] and an [online renderer][cm render]. Less-commonly used
markups are:

- `![alt text](url)`: in-line images.

[cm spec]: https://spec.commonmark.org/current/
[cm render]: https://commonmark.org/help/


Disqus
------

Disqus uses the following [html tags][disqus]:
- Block: `<br>` (needs no close), `<blockquote>`, `<p>`, `<pre>`.
- Links: `<a href='...'>`.
- Inline: `<code>`, `<strong>`/`<b>`, `<em>`/`<i>`, `<strike>`/`<s>`,
  `<span>`, `<caption>`, `<cite>`, `<spoiler>`.

Code blocks can be done with `<pre><code class="...">` with any of the
following languages as _class_: Bash, Diff, JSON, Perl, C#, HTML/XML
(tags must be encoded), Java, Python, C++, HTTP, JavaScript, Ruby, CSS
Ini, PHP, SQL.

[disqus]: https://help.disqus.com/commenting/what-html-tags-are-allowed-within-comments


StackExchange
-------------

From the [help page][se-help].

Differences from Markdown:
- Must have a blank line between a paragraph and following list.
- 8-col additional indent for code blocks in lists, 4-col suggested
  over 3 for sublists. Additional paras in lists work.
- Lists, code blocks work in quotes.
- [Limited subset][se-html] of HTML allowed; spacing, double quotes,
  attribute order etc. must be correct to keep tag from being
  stripped.

Extras:
- `<kbd>...</kbd>` Displays text as "key" box.
- `[tag:NAME]` for a boxed link to tag _NAME_.
- `>!` starting a line gives "spoiler" blockquote.

[Code formatting][se-code] is done with the standard four-space indent
or triple-backticks. Syntax highlighting is automatic with default
and specific language hints [based on the tags][se-taglang]. Override
this for the following block or all following blocks with HTML comments
that specify the SO tag or [Google Prettify][se-googpret] `lang-` class
names:

    <!-- language: lang-js -->
    <!-- language: bash -->
    <!-- language-all: lang-none -->

Keyboard shortcuts on selected text:
- Ctrl-I/B: Toggle italics/bold.
- Ctrl-L: Selected text to link.
- Ctrl-H: cycle through header styles.
- Ctrl-U/O: Toggle unnumbered/ordered list.
- Ctrl-G: Insert image.

#### [Comment-only Markup][se-comment]

`@name` will notify someone who's previously commented on the same post.
Only first name is necessary; append chars from addititional names to
disambiguate if necessary. Always remove spaces. If no natural first/last
name, three chars minimum. Also works for post editors and the ♦ moderator
who closed a question.

Links. Link text is given in quotes, or is the site name if linking to
another site. Capitalization is usually preserved when generating link
text.
- `[NAME.se]`: `NAME.stackexchange.com`, if exists.
- `[ubuntu.se]` Ask Ubuntu.
- `[so]`, `[pt.so]`, `[su]`, `[sf]`, `[metase]`, `[a51]`, `[se]`: SE site.
- `[meta]`: Meta site for current site.
- `[main]`: Base site from meta site.
- `[edit]`: "edit", edit page for post (`/posts/{id}/edit`).
- `[tag:tagname]`, `[meta-tag:tagname]`: Tag's page.
- `[help],` `[help/on-topic]`, `[help/dont-ask]`, `[help/behavior]`,
  `[meta-help]`. "help center". All links point to the main site.
- `[tour]`: "tour", tour page.
- `[chat]`: "{site name} Chat", chat site.
- `[ask],` `[answer]`: How to Ask, How to Answer.


#### Image Sizing

The Markdown extensions for image sizing don't work, but you can use
[`<img>` tags][se-html] to resize images on display if you're careful
about the _exact_ formatting. This includes properties names, the order
of properties, double-quotes, and spacing; getting any of these wrong
will cause the tag to be stripped.

    src=""
    width=""    up to 999; do not include the 'px' extension
    height=""   up to 999; do not include the 'px' extension
    alt=""
    title=""

Working example:

    <img src="https://i.stack.imgur.com/Xaqf0.png" width="200" height="100" alt="alt text" title="title text"/>

[se-code]: https://unix.stackexchange.com/help/formatting
[se-comment]: https://retrocomputing.meta.stackexchange.com/editing-help#comment-formatting
[se-googpret]: https://github.com/google/code-prettify
[se-help]: https://retrocomputing.meta.stackexchange.com/editing-help
[se-html]: https://meta.stackexchange.com/q/1777/142445
[se-taglang]: https://meta.stackexchange.com/q/72082/142445

### stackoverflow.blog

HTML formatting seems to be accepted. Use `<code>…</code>` for in-line
fixed-width formatting.


Telegram
--------

The formatting you add to messages seems to [vary by client][tg-vary].
[These tests on an old version][tg-clients] show some of the
not-too-major differences.

The desktop clients offer [keyboard shortcuts][tg-desktop] to format
text after selecting it: __Ctrl-B__ for bold, __Ctrl-I__ for italic,
__Ctrl-Shift-M__ for monospace and __Ctrl-K__ to enter a URL for a
link.

Textual markup:
- `__italic__`, `**bold**` and `` `monospace` ``
- Multi-line code blocks can be delimited with three backticks before
  and after. (These need not be on separate lines.)
- URLs will automatically be turned into links, but to link text
  without showing the URL you need to use Ctrl-K as above.
- `@name` will be replaced with a clickable representation of the
  channel user matching _name_ (does completion).
- `#text` will make _text_ a hashtag and link to a search for that
  hashtag.

[tg-clients]: https://telegra.ph/markdown-07-07
[tg-desktop]: https://www.techmesto.com/telegram-desktop-now-supports-text-formatting-using-keyboard-shortcuts/
[tg-vary]: https://www.reddit.com/r/Telegram/comments/5eh3uk/how_do_i_format_text_without_using_bots/daceczy/


YouTube
-------

- Markdown-like: `*bold*`, `_italic_`, `-strikethrough text-`.
- Bare links only.


MediaWiki/Wikipedia Wikitext
----------------------------

Reference: [[Wikitext]].

#### General Inline Formatting

- Unicode non-breaking spaces, `&nbsp;`, `{{Nowrap| this and that}}`.
- `''italics''`, `'''bold'''`, `'''''italic+bold'''''`.
- `<code>computer text</code>`
- `<sub>subscript</sub>`, `<sup>superscript</sup>`.
- `<small>smaller text</small>` can be useful for "small caps."
- [Math][wt math]: `<math>LaTeX code</math>`.

#### General Block Formatting

- Two newlines for paragraph break; `<br/>` for line break.
- Indented paragarphs use one or more `:` at start of line.
- `<blockquote>...</blockquote>`
- Sections: `= Level 1 =`, `== Level 2 ==`.
- Lists: `* Level 1`, `** Level 2`; `#` for numbered lists.
- Description lists: `; Term : Definition`, or multiple definitions on new
  lines starting with `:`.

#### Links

- "Free links" to pages: `[[Page Name]]`, `[[Page Name#section name]]`,
  `[[#section]]`.
- Renamed links: `[[Page Name#section|text to display]]`, or
  `[[Page Name|]]` for automatic renaming (removal of parens, etc.)
- Blending: `[[Page]]es`. Suppressed: `[[Page]]<nowiki/>ing`.
- External links: `[http://foo.com text to display]`.

[wikitext]: https://en.wikipedia.org/wiki/Help:Wikitext
[wt math]: https://en.wikipedia.org/wiki/Help:Displaying_a_formula


WordPress
---------

Comments allow limited HTML markup, as determined by the [KSES filter].
This may be configured differently on a per site basis, but generally will
be something like the following.

    <a href title>
    <abbr title>
    <acronym title>
    <b>
    <blockquote cite>
    <cite>
    <code>
    <del datetime>
    <em>
    <i>
    <q>
    <s>
    <strike>
    <strong>

[KSES filter]: https://core.trac.wordpress.org/browser/trunk/src/wp-includes/kses.php#L414
