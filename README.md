# Markdown-to-HTML
A parser written in SML to convert markdown to HTML syntax.


### Design Decisions -
- Converted all tabs to 4 whitespaces
- The lines which contain only white spaces after converting are made empty
- The processing is done line by line

### Usage -

- HEADINGS - `#`s (upto 6 levels) ends at the line itself

- BOLD AND ITALICS - Nested bold and italics words but one cannot start bold in one line and end in the next. To do it one must use bold separately for both the lines. Similar for italics

- HORIZONTAL RULING - 3 or more consecutive `-` anywhere in the same line makes a horizontal rule

- BLOCK QUOTES - The line must immediately start from `>`. Also only consecutive `>` s will be rendered in case of nested block quotes.

- LISTS - Ordered lists are recognised when the start of the line contains a number followed by a `.` The ordered lists continue when there is at least one whitespace in the following line. To move to next numbered list, leave a line (i.e. 2 "/n") empty between two lines

- LINKS - `[text](http://url)` syntax and also the automatics link feature

- CODE BLOCKS - 8 or more spaces will make the text render as plaintext

- TABLES - first line must be `<<` and last line `>>`. In between these, to separate the entries column wise, use `|` as the separator
