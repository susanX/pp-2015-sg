#lang racket
;S Gooding sgoodi02
;This program is a work in progress.

(define sudoku '((0 2 5 0 0 1 0 0 0)
                 (1 0 4 2 5 0 0 0 0)
                 (0 0 6 0 0 4 2 1 0)
                 (0 5 0 0 0 0 3 2 0)
                 (6 0 0 0 2 0 0 0 9)
                 (0 8 7 0 0 0 0 6 0)
                 (0 9 1 5 0 0 6 0 0)
                 (0 0 0 0 7 8 1 0 3)
                 (0 0 0 6 0 0 5 9 0)))

(define set '(1 2 3 4 5 6 7 8 9))
(define new-list '())

;transform gets one row. Fills in sets of 1-9 or singleton values.
;adds a number of sudoku row till the row is done and it gets to null. 
(define (transform sudoku set)
   (if (null? sudoku) 
      '()
      (cons        
       (if (zero? (car sudoku))
          set ;item 1. ? of cons if O.
          (cons (car sudoku) '())) ;item 1. ? of cons if 1-9.
       (transform (cdr sudoku) set))));item 2. of cons. recall. 
 
;row-builder gets another row.
(define (row-builder sudoku set new-list)
   (if (null? sudoku)
     '()
      (cons
         (transform (car sudoku) set )
         (row-builder (cdr sudoku) set new-list))))

(define (controller sudoku set new-list)
    (row-builder sudoku set new-list) ;
  ;next procedure 
  )

(controller sudoku set new-list)