;(use gauche.interactive)
(use text.html-lite)
(use text.tree)

(define expr '(#\! #\space #\* #\+ #\# #\- #\@ #\$ #\% #\\))

(define-class <node> ()
    ((key :init-keyword :key :accessor key-of)
     (value :init-keyword :value :accessor value-of)
     (left :init-keyword :left :accessor left-of)
     (right :init-keyword :right :accessor right-of)
     (parent :init-keyword :parent :accessor parent-of)))

(define (include? xn n)
    (if (> (length xn) 0)
        (let ((x (car xn)))
            (if (eq? x n)
                #t
                (include? (cdr xn) n)))
        #f))

(define (set-of node lines)
    (if (> (length lines) 0)
        (let ((line (car lines)))
            (set! (left-of node)
                (cond 
                    ((eq? 0 (length line))
                        (make <node> 
                            :key #\&
                            :value ""
                            :parent node))
                    ((include? expr (car line))
                        (make <node> 
                            :key (car line)
                            :value (list->string (cdr line))
                            :parent node))
                    (else
                        (make <node>
                            :key #\^
                            :value (list->string line)
                            :parent node))))
            (set-of (left-of node) (cdr lines)))))
    
(define (parse-node node)
    (let ((key (key-of node)) (value (html-escape-string (value-of node))))
        (tree->string
            (cond
                ((eq? key #\!)
                    (html:h3 value))
                ((eq? key #\@)
                    (html:p :class "date" value))
                ((eq? key #\space)
                    (html:pre value))
                ((eq? key #\%)
                    (html:img :src value :alt value))
                ((eq? key #\$)
                    (if (string=? "$" (substring value 0 1))
                        (let ((_value (substring value 1 (string-length value))))
                            (html:p (html:a :href _value _value)))
                        (html:p (html:a :href value :target "_blank" value))))
                ((eq? key #\-)
                    (html:hr))
                ((eq? key #\&)
                    (html:br))
                ((eq? key #\\)
                    (html:p value))
                ((eq? key #\^)
                    (html:p value))
                (else
                    "")))))

;(describe node)
(define (view-of node str)
    (define html (string-append str (parse-node node)))
    (if (slot-bound? node 'left)
        (view-of (left-of node) html)
        html))

(define (wiki2list fname)
    (with-input-from-file fname
        (lambda ()
            (let loop ((xn '()) (line (read-line)))
                (if (eof-object? line)
                    (reverse xn)
                    (loop (cons (string->list line) xn)
                          (read-line)))))))

(define root (make <node> 
    :key #f
    :value #f
    :parent #f))

(define (wiki fname)
    (let ((lines (wiki2list fname)))
        (set-of root lines)
        (view-of root "")))