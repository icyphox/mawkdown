#!/usr/bin/awk -f
# 

BEGIN {
    in_code = 0
    in_list_unordered = 0
    in_list_ordered = 0
    in_paragraph = 0
    in_blockquote = 0
}

{
    # escape < > characters
    gsub(/</, "\<");
    gsub(/>/, "\>");

    # match italics
    if(match($0, /_(.*?)_/)) {
        s = sprintf("<em>%s</em>", substr($0, RSTART+1, RLENGTH-2))
        gsub(/_(.*?)_/, s)
    }

    # match bold
    if(match($0, /\*(.*?)\*/)) {
        s = sprintf("<strong>%s</strong>", substr($0, RSTART+1, RLENGTH-2))
        gsub(/\*(.*?)\*/, s)
    }

    # match inline code
    if(match($0, /`([^`]*)`/)) {
        s = sprintf("<code>%s</code>", substr($0, RSTART+1, RLENGTH-2))
        gsub(/`([^`]*)`/, s)
    }

    # automatic links
    if(match($0, /<(http[s]?:\/\/.*)>/)) {
        link = substr($0, RSTART+1, RLENGTH-2)
        s = sprintf("<a href=%s>%s</a>", link, link)
        gsub(/<(http[s]?:\/\/.*)>/, s)
    }

    # automatic mailto links
    if(match($0, /<(.*@.*\..*)>/)) {
        link = substr($0, RSTART+1, RLENGTH-2)
        s = sprintf("<a href=mailto:%s>%s</a>", link, link)
        gsub(/<(.*@.*\..*)>/, s)
    }


    # close code blocks
    if(! match($0, /^    /)) {
        if(in_code) {
            in_code = 0
            printf "</code></pre>\n"
        }
    }

    if (! match($0, /^> /)) {
        if(in_blockquote) {
            in_blockquote = 0
            printf "</blockquote>\n"
        }
    }

    # close unordered list
    if(! match($0, /^- /)) {
        if(in_list_unordered) {
            in_list_unordered = 0
            printf "</ul>\n"
        }
    }

    # close ordered list
    if(! match($0, /^[0-9]+\. /)) {
        if(in_list_ordered) {
            in_list_ordered = 0
            printf "</ol>\n"
        }
    }

    # display titles
    if(match($0, /^(#+)/)) {
        printf "<h%i>%s</h%i>\n", RLENGTH, substr($0, index($0, $2)), RLENGTH
    # display code blocks
    } else if(match($0, /^    /)) {
        if(in_code == 0) {
            in_code = 1
            printf "<pre><code>"
            print substr($0, 5)
        } else {
            print substr($0, 5)
        }
    # match blockquote
    } else if(match($0, /^> /)) {
        if(in_blockquote == 0) {
            in_blockquote = 1
            printf "<blockquote>\n"
            print substr($0, 3)
        } else {
            print substr($0, 3)
        }
    # display unordered lists
    } else if(match($0, /^- /)) {
        if(in_list_unordered == 0) {
            in_list_unordered = 1
            printf "<ul>\n"
            printf "<li>%s</li>\n", substr($0, 3)
        } else {
            printf "<li>%s</li>\n", substr($0, 3)
        }

    # display ordered lists
    } else if(match($0, /^[0-9]+\. /)) {
        n = index($0, " ") + 1
        if(in_list_ordered == 0) {
            in_list_ordered = 1
            printf "<ol>\n"
            printf "<li>%s</li>\n", substr($0, n)
        } else {
            printf "<li>%s</li>\n", substr($0, n)
        }

    # close p if current line is empty
    } else {
        if(length($0) == 0 && in_paragraph == 1 && in_code == 0) {
            in_paragraph=0
            printf "</p>\n"
        } # we are still in a paragraph
        if(length($0) != 0 && in_paragraph == 1) {
            print
        } # open a p tag if previous line is empty
        if(length(previous_line) == 0 && in_paragraph == 0) {
            in_paragraph=1
            printf "<p>%s\n", $0
        }
    }
    previous_line = $0
}

END {
    if(in_code) {
        printf "</code></pre>\n"
    }
    if(in_list_unordered) {
        printf "</ul>\n"
    }
    if(in_list_ordered) {
        printf "</ol>\n"
    }
    if(in_paragraph) {
        printf "</p>\n"
    }
    if(in_blockquote) {
        printf "</blockquote>\n"
    }
}

