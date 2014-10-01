#!/usr/local/bin/gosh

(use text.html-lite)
(use text.tree)
(use file.util)
(include "lib/wiki.scm")
(include "setting.scm")

(define (main arg)
    (display content-type)
    (write-tree (html-doctype))
    (write-tree
        (html:html :lang 'ja
            (html:head
                (html:meta :charset charset)
                (html:title title)
                (html:link
                    :rel "stylesheet"
                    :type "text/css"
                    :href "css/style.css")
                )
            (html:body
                (html:div :id "header"
                    (html:h3 title)
                    (html:p
                        (html:a
                            :href "edit.scm"
                            "投稿"))
                 )
                (html:div :id "content"
                    (map
                        (lambda (fn)
                            (tree->string 
                                (html:div :class "post" (wiki fn))))
                        (reverse 
                            (directory-list save_dir
                                :add-path? #t 
                                :children? #t)))
                )
                (html:div :id "footer"
                    (html:p "author: " author " / " footer)
                )
            )
        )
    ))
