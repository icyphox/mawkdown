MAWKDOWN

A quick and dirty awk script to convert markdown to HTML. I don't plan
to implement the full spec, because I have other things to do and
I don't really need tables, etc.

Here's what's been done so far:

- automatic links: https://example.com
- automatic emails: <x@abc.com>
- in-line formatting: *bold*, _italics_, `code`
- code blocks:

    four space indent

- ordered and unordered lists
- headers: #, ## and so on
- blockquotes: > text
- links: [adsf](https://asdf.com)
- images: ![alt text](https://some.com/img.png)

What's being worked on:

- footnotes: [^text]

USAGE

mawkdown reads markdown from STDIN or a file and spits the rendered HTML
to STDOUT. 

    $ ./m.awk file.md > out.html
    $ printf '## some markdown\n' | ./m.awk > out.html

CREDITS

Solene Rapenne <solene@perso.pw> for having written the initial markdown
processor.
