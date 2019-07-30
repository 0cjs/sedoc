Text Format Codes
=================

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
- `[tag:NAME]` for a boxed link to tag _NAME_.
- `>!` starting a line gives "spoiler" blockquote.

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


<!-------------------------------------------------------------------->
[disqus]: https://help.disqus.com/commenting/what-html-tags-are-allowed-within-comments
[se-html]: https://meta.stackexchange.com/q/1777/142445
[se-help]: https://retrocomputing.meta.stackexchange.com/editing-help
[se-comment]: https://retrocomputing.meta.stackexchange.com/editing-help#comment-formatting
