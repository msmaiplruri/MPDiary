#!/usr/local/bin/gosh

(use www.cgi)
(use text.html-lite)
(use text.tree)
(include "setting.scm")

(define params (cgi-parse-parameters))

(define (main arg)
    (display content-type)
    (with-output-to-file 
        (string-append 
            save_dir "/" (cgi-get-parameter "date" params) ".wiki")
        (lambda () 
            (display 
                (cgi-get-parameter "content" params))))
    (write-tree
        (html:meta
            :http-equiv "refresh"
            :content (string-append "0;URL=" home))))
