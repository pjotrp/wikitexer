WikiTeXer is created to allow Mediawiki input and
generate HTML or LaTeX output. The reasoning is that TeX is great for output, but
not so friendly for users. Also, I needed a tool that would:

1. Allow a mixture of Wiki language and LaTeX input
2. Generate HTML to Word/OpenOffice document formats
3. Generate LaTeX -> PS -> PDF

There is a plethora of tools that comes some way towards achieving
this goal.  However, there are downsides for each. I did not want a
Wiki based HTML server, I just want to use the command line. You may
want to consider the [deplate
program](http://deplate.sourceforge.net/) instead, as it does get a
lot of things right. But, for me, the architecture was too complex to
start hacking it.

Ultimately the architecture should be simple and allow contained HTML
for HTML output and contained LaTeX for LaTeX output. Much of the
complexity of existing systems is that they cater to either pure LaTeX
(like latex2html), or HTML (many wysiwyg examples), or XML (docbook,
XML/FO). Where the latter is about rendering, and less about usage

LaTeX itself is a great system for publishing (less so for interactive
systems). My main criticism is that LaTeX (or TeX) is not so readable
in terms of syntax. Some wiki style syntax just gets less in the way.
I like to read

  This '''word''' is ''emphasized''

instead of

  This \textbf{word} is \emph{emphasized}

I like markup for headers

  == header ==

instead of 

  \subsection{header}

Though the benefit is smaller there.

For typing I want something even less in the way, but I still want to
generate powerful output, the way LaTeX does. And I want to generate
HTML, which I can convert to Microsoft Word/OpenOffice, for those
collaborators/co-authors who can not deal with LaTeX (yes, they
exist!).

So I thought it would be nice to have a LaTeX environment where one could replace some
of the common markup with Wiki-style markup. Also macro's would be nice in a
modern language, say Ruby.  Finally we need great output. Converting figures
between LaTeX and HTML can be done transparently.  However, tables are a
difficult problem. My choice is to support native LaTeX tables and native HTML
tables - as I tend to generate them anyway. Maybe later a external converter
can be used to handle translation automatically as a plugin.

The latest is that WikiTeXer works, is fast, and delivers the goods.
It even supports bibtex parsing, and generating HTML bibliographies.
These last years I have use WikiTeXer for paper writing - and now I am
writing my thesis with it.

WikiTeXer has some shortcomings. The parser is regex based - it should
really be a proper token parser. Also, I should refactor some of the
modules and method namings. Still, the code is easy to adapt - feel
free to do so.

In the process of writing this software, I started to appreciate the
work of Donald Knuth even more!

Pjotr Prins.

# Install and run

    https://github.com/pjotrp/wikitexer.git
    cd wikitexer
    ./bin/wikitexer --help

# Input

WikiTeXer takes a mixture of markup, LaTeX and HTML as input.
Input it does not recognise is left alone.

## Markup (Wikimedia style)

### #if and #endif

Output this section of text to HTML only

    #if HTML
    Output this text for HTML only
    #endif

Output this section of text to LaTeX only

    #if LaTeX
    Output this text for LaTeX only
    #endif

Output this section of text when in DRAFT mode

    #if DRAFT
    Output this text in DRAFT mode only
    #endif


## LaTeX

## HTML

# Output

WikiTeXer generates LaTeX or HTML

## LaTeX

To generate LaTeX simply use the --latex switch of wikitexer.

The LaTeX style is defined in a user provided 'wtstyle.tex', which
should include the documentclass.

## HTML

## All modes

### Draft vs final mode

When WikiTeXer is running in draft mode (i.e. when the --final switch
is not used) some extra functionality is switched on. For example
color codings, keyword formatting, see the file keywordformatting.rb, and
highlighting the first sentence of a paragraph.

# License

WikiTeXer by Pjotr Prins (c) 2012, is published under a BSD license, see LICENSE.txt


