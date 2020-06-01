MAWKDOWN

A quick and dirty awk script to convert markdown to HTML. I don't plan
to implement the full spec, because I'm not retarded and I don't need
things like tables etc. 

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
