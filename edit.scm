#!/usr/local/bin/gosh

(use text.html-lite)
(use text.tree)
(use srfi-19)
(include "setting.scm")
(include "lib/utility.scm")

(define (main arg)
    (define edit_title (string-append title " edit"))
    (display content-type)
    (write-tree (html-doctype))
    (write-tree
        (html:html :lang 'ja
            (html:head
                (html:meta :charset charset)
                (html:title edit_title)
                (html:link
                    :rel "stylesheet"
                    :type "text/css"
                    :href "css/style.css")
            )
            (html:body
                (html:div :id "header"
                    (html:h3 edit_title)
                    " "
                    (html:a
                        :href home
                        "home")
                ) 
                (html:div :id "content"
                    (html:form 
                        :method "POST"
                        :action "create.scm"
                        (html:input
                            :name "now"
                            :value 
                                (string-append
                                    "@(" (get-time c-date) ")"))
                        (html:textarea 
                            :id "main"
                            :name "content" 
                            (template)
                        )
                        (html:input
                            :name "date"
                            :type "hidden"
                            :value now)
                        (html:br)
                        (html:input
                            :type "submit"
                            :value "submit")
                    )
                )
                (html:div :id "footer"
                    (html:p "author: " author)
                )
            ))))

