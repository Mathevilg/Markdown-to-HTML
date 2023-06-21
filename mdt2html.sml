val input = TextIO.openIn "my.txt"
val s = String.explode(TextIO.inputAll(input))


(* tabs to space *)

fun tabtospace(s, eval) = 
    if s = [] then List.rev(eval)
    else 
        if hd(s) = #"\t" then tabtospace(tl(s), #" " :: #" " :: #" " :: #" " :: eval)
        else tabtospace(tl(s), hd(s) :: eval)

val s1 = tabtospace(s, [])


fun reader(s, l : char list , y : string list) = 
    if (s=[]) then List.rev(String.implode(List.rev(l))::y)
    else    
        if (hd(s) = #"\n") then 
            reader(tl(s), [], String.implode(List.rev(l))::y)
        else 
            reader(tl(s), hd(s)::l, y)

val z = reader(s1, [], [])





(* Below is code blocks *)

fun isCodeblock(l, b, i) = 
    if (i=8 andalso b) then true
    else 
        if (i<8 andalso List.length(l) <> 0 andalso hd(l) = #" " andalso b) then isCodeblock(tl(l), true, i+1)
        else false

fun codeblock(z, eval) = 
    if z = [] then List.rev(eval)
    else 
        if isCodeblock(String.explode(hd(z)), true, 0) then codeblock(tl(z), "<pre><code>"^hd(z)^"</code></pre>" :: eval)
        else codeblock(tl(z), hd(z) :: eval)

val a = codeblock(z, [])

(* Below is bold and italics *)

fun bni_line(l, italics, bold, eval) = 
    if l = [] then String.implode(List.rev(eval))
    else 
        if hd(l) = #"*" then
            if hd(tl(l)) = #"*" then 
                if bold then bni_line(tl(tl(l)), italics, not bold, #">" :: #"b" :: #"/" :: #"<" :: eval)
                else bni_line(tl(tl(l)), italics, not bold, #">" :: #"b" :: #"<" :: eval)
            else 
                if italics then bni_line(tl(l), not italics, bold, #">" :: #"i" :: #"/" :: #"<" :: eval)
                else bni_line(tl(l), not italics, bold, #">" :: #"i" :: #"<" :: eval)
        else bni_line(tl(l), italics, bold, hd(l) :: eval)

fun bni(z, eval) = 
    if z = [] then List.rev(eval)
    else bni(tl(z), bni_line(String.explode(hd(z)), false, false, []) :: eval)

val b = bni(a, [])

(* Below is table *)

fun startTable(l) = 
    let val lst = String.tokens(fn c => c = #" ")(l)
    in
        if (List.length(lst) = 1 andalso hd(lst) = "<<") then true
        else false
    end

fun endTable(l) = 
    let val lst = String.tokens(fn c => c = #" ")(l)
        in
            if (List.length(lst) = 1 andalso hd(lst) = ">>") then true
            else false
        end

fun table_line(l, eval) = 
    if l = [] then "<TR>"^eval^"</TR>"
    else table_line(tl(l), "<TD>"^hd(l)^"</TD>"^eval)
    

fun table(z, b, eval) = 
    if z = [] then List.rev(eval)
    else 
        if startTable(hd(z)) then
            table(tl(z), true, "<CENTER><TABLE border='1'>" :: eval)
        else 
            if endTable(hd(z)) then table(tl(z), false, "</TABLE></CENTER>" :: eval)
            else 
                if b then table(tl(z), b, table_line(String.tokens(fn c => c = #"|")(hd(z)), "")::eval)
                else table(tl(z), b, hd(z)::eval)

val c = table(b, false, [])

(* Below is heading *)

fun header_line(l,i) = 
    if l = [] then ""
    else
        if (hd(l) = #"#" andalso i<8) then header_line(tl(l),i+1)
        else 
            if (i = 0) then String.implode(l)
            else 
                let 
                    val tag = String.implode(#"<" :: #"h" :: Char.chr(i+48) :: [#">"])
                    val tag1 = String.implode(#"<" :: #"/" :: #"h" :: Char.chr(i+48) :: [#">"])
                in 
                    tag^String.implode(l)^tag1
                end

fun header(z, eval) = 
    if (z = []) then List.rev(eval)
    else header(tl(z), header_line(String.explode(hd(z)), 0) :: eval)

val d = header(c, [])

(* Below is hr *)

fun hr_line(l, eval) = 
    if l=[] then String.implode(List.rev(eval))
    else 
        if (List.length(l) > 3) andalso (hd(l) = #"-") andalso (hd(tl(l)) = #"-") andalso (hd(tl(tl(l))) = #"-") andalso (hd(tl(tl(tl(l)))) = #"-") then hr_line(tl(l), eval)
        else
            if ((List.length(l) = 3) andalso (hd(l) = #"-") andalso (hd(tl(l)) = #"-") andalso (hd(tl(tl(l))) = #"-")) orelse ((List.length(l) > 3) andalso (hd(l) = #"-") andalso (hd(tl(l)) = #"-") andalso (hd(tl(tl(l))) = #"-") andalso (hd(tl(tl(tl(l)))) <> #"-")) then hr_line(tl(tl(tl(l))), #">" :: #"r" :: #"h" :: #"<" :: eval)
            else hr_line(tl(l), hd(l) :: eval)

fun hr(z, eval) = 
    if z = [] then List.rev(eval)
    else hr(tl(z), hr_line(String.explode(hd(z)), []) :: eval)

val e = hr(d, [])

(* Below is for paragraphs *)

(* fun para(z, eval) = 
    if (z = []) then List.rev(eval)
    else 
        if (List.length(String.tokens(fn c => c = #" ")(hd(z))) = 0) then para(tl(z), "<p></p>" :: eval)
        else para(tl(z), hd(z) :: eval) 

val f = para(e, []) *)

(* Below is hyperlink *)

(* fun hyperlink_line(l, eval, b) = (* l is a string representing a line *)
    if String.isSubstring ("<https://") (l) or String.isSubstring("<http://") then
        if l=[] then String.implode(List.rev(eval))
        else 
            if 
        if s.isSubstring("http://") then "http://"^s
        else 
            if String.isPrefix("https://", s) then "https://"^s
            else s
    else l

fun hyperlink_line(l, eval, b) = 
    if l = [] then String.implode(List.rev(eval))
    else 
        if List.length(l) > 4 andalso hd(l) = #"<" andalso hd(tl(l)) = #"h" andalso hd(tl(tl(l))) = #"t" andalso hd(tl(tl(tl(l)))) = #"t" andalso hd(tl(tl(tl(tl(l))))) = #"p" then
            hyperlink_line(tl(tl(tl(tl(tl(l))))), ) *)

(* fun hyperlink_line(l) =
    let 
        val x = Strings.tokens(fn c => c = " ")(l)
    in

    end

fun hyperlink(z, eval) = 
    if z = [] then List.rev(eval)
    else hyperlink(tl(z), hyperlink_line(hd(z)) :: eval) *)


(* Below is Block Quotes *) 

fun BQ_line(l, eval, b) = 
    if l = [] then String.implode(List.rev(eval))
    else 
        if hd(l) = #">" andalso b then "<blockquote>"^BQ_line(tl(l),  eval, true)^"</blockquote>"
        else BQ_line(tl(l), hd(l) :: eval,  false)

fun BQ(z, eval) = 
    if z = [] then List.rev(eval)
    else BQ(tl(z), BQ_line(String.explode(hd(z)), [], true) :: eval)

val f = BQ(e, [])

(* Below is list *)

fun isList(l, b) = 
    if List.length(l) > 0 andalso (hd(l) = #"0" orelse hd(l) = #"1" orelse hd(l) = #"2" orelse hd(l) = #"3" orelse hd(l) = #"4" orelse hd(l) = #"5" orelse hd(l) = #"6" orelse hd(l) = #"7" orelse hd(l) = #"8" orelse hd(l) = #"9") andalso b then 
        if List.length(l) > 1 andalso hd(tl(l)) = #"." then true
        else isList(tl(l), true)
    else false

fun List_line(l) = 
    if List.length(l) > 0 andalso (hd(l) = #"0" orelse hd(l) = #"1" orelse hd(l) = #"2" orelse hd(l) = #"3" orelse hd(l) = #"4" orelse hd(l) = #"5" orelse hd(l) = #"6" orelse hd(l) = #"7" orelse hd(l) = #"8" orelse hd(l) = #"9") then 
        if List.length(l) > 1 andalso hd(tl(l)) = #"." then String.implode(tl(tl(l)))
        else List_line(tl(l))
    else String.implode(l)

fun List(z, eval, b) = 
    if z = [] then List.rev(eval)
    else 
        if isList(String.explode(hd(z)), true) then
            if not b then List(tl(z), "<ol><li>"^List_line(String.explode(hd(z))) :: eval, true)
            else List(tl(z), "<li>"^List_line(String.explode(hd(z))) :: eval, true)
        else 
            if b then
                if hd(z) = ""  then List(tl(z), "</li></p><p>" :: eval, true)
                else 
                    if hd(String.explode(hd(z))) <> #" " then List(tl(z), "</ol>"^hd(z) :: eval, false)
                    else List(tl(z), hd(z) :: eval, true)
            else 
                if hd(z) = ""  then List(tl(z), "</p><p>" :: eval, false)
                else List(tl(z), hd(z) :: eval, false)


val g = List(f, [], false)

(* Below is Output *)

val output_file = TextIO.openOut("input.html")

fun write([]) = TextIO.closeOut output_file
  | write(x::xs) = 
    let val _ = TextIO.output(output_file,x) 
    val _ = TextIO.output(output_file,"\n") 
    in write(xs) 
    end

val _ = write(g)
val _ = TextIO.closeOut output_file