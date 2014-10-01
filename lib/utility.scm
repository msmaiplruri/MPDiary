(use srfi-19)

(define (number->weekday n)
    (vector-ref (vector "日" "月" "火" "水" "木" "金" "土") n))

(define (get-weekday d)
    (let ((s_weekday (date->string d "~w")))
        (number->weekday (string->number s_weekday))))

(define (get-time d) (date->string d "~3"))

(define (get-date d)
    (let ((date (date->string d "~Y.~m/~d"))
          (weekday (get-weekday d)))
        (string-append 
            "@" date " [" weekday "]"
            "\n\n\n\n"
            "@(" (get-time d) ")\n")))


(define (file2list fname)
    (with-input-from-file fname
        (lambda ()
            (let loop ((xn '()) (line (read-line)))
                (if (eof-object? line)
                    (reverse xn)
                    (loop (cons (string->list line) xn)
                          (read-line)))))))

(define c-date (current-date))

(define now (date->string c-date "~Y~m~d"))

(define (template)
    (let ((fn (string-append save_dir "/" now ".wiki")))
        (if (file-exists? fn)
            (string-join (map list->string (file2list fn)) "\n")
            (get-date c-date))))


