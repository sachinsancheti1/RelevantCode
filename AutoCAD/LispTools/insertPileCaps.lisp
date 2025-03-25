; Define the main function
(defun c:InsertBlocksArchiPC1 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc1")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((43025 5287 300)
      (26617 277 300)
      (26617 7325 300)
      (11361 17875 300)
      (10713 26438 300)
      (10713 35600 300)
      (43025 11435 300)
      (41107 26438 300)
      (51583 17950 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC1 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC1' to run the program.")
(princ)



; Define the main function
(defun c:InsertBlocksArchiPC2 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc2")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((43025 17950 300)
      (32425 32264 300)
      (26757 15683 300)
      (26617 22922 300)
      (17712.5 22962 300)
      (41107 35600 300)
      (5522 12600 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC2 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC2' to run the program.")
(princ)



; Define the main function
(defun c:InsertBlocksArchiPC3 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc3")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((27224 32264 300)
        (21609 26328 300)
        (21609 28356 300)
        (17296 35728 300)
        (36144 5287 300)
        (36144 11435 300)
        (26757 11510 300)
        (49742 5287 300)
        (49742 11435 300)
        (49742 17950 300)
        (23758 28356 300)
        (32628 237 300)
        (49707 31300 300)
        (17261 32274 300)
        (23724 26328 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC3 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC3' to run the program.")
(princ)


; Define the main function
(defun c:InsertBlocksArchiPC4 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc4")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((46448 237 300)
      (49920 40113 300)
      (27224 26288 300)
      (39602 237 300)
      (1963 22962 300)
      (17675 12600 300)
      (49871 237 300)
      (1900 40113 300)
      (8795 237 300)
      (12305 -3781 300)
      (15699 -3781 300)
      (19093 -3781 300)
      (22487 -3781 300)
      (25881 -3781 300)
      (29275 -3781 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC4 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC4' to run the program.")
(princ)

; Define the main function
(defun c:InsertBlocksArchiPC5 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc5")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((2078 31300 300)
        (32668 7250 300)
        (43025 22962 300)
        (32668 22962 300)
        (23723 35710 300)
        (32425 26288 300)
        (6372 35750 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC5 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC5' to run the program.")
(princ)



; Define the main function
(defun c:InsertBlocksArchiPC6 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc6")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((38225 17950 300)
        (32668 11435 300)
        (1963 35750 300)
        (27049 38445 300)
        (17178 26328 300)
        (36766 35750 300)
        (45448 35750 300)
        (49742 26288 300)
        (5372 277 300)
        (49817 22962 300)
        (11511 22962 300)
        (5407 17950 300)
        (1963 7250 300)
        (12305 237 300)
        (32425 35750 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC6 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC6' to run the program.")
(princ)



; Define the main function
(defun c:InsertBlocksArchiPC7 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc7")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((21447 32274 300)
      (36069 17950 300)
      (38225 22962 300)
      (43025 237 300)
      (36179 237 300)
      (1940 277 300)
      (1963 12600 300)
      (1963 17950 300)
      (5407 22962 300)
      (23723 32274 300)
      (49857 35750 300)
      (45448 40113 300)
      (41107 40113 300)
      (36766 40113 300)
      (32425 40113 300)
      (23723 40113 300)
      (19395 40113 300)
      (15054 40113 300)
      (10713 40113 300)
      (6372 40113 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC7 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC7' to run the program.")
(princ)




; Define the main function
(defun c:InsertBlocksArchiPC8 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc8")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((6372 26253 300)
      (41159 31300 300)
      (51583 40113 300)
      (51583 35750 300)
      (51583 31300 300)
      (51583 26850 300)
      (51583 22400 300)
      (51583 13500 300)
      (51583 9050 300)
      (51583 4600 300)
      (237 40113 300)
      (237 35750 300)
      (237 31300 300)
      (22487 17985 300)
      (51583 237 300)
      (32669 -3781 300)
      (237 237 300)
      (237 26850 300)
      (237 4600 300)
      (237 9050 300)
      (237 13500 300)
      (237 22400 300)
      (237 17950 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC8 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC8' to run the program.")
(princ)



; Define the main function
(defun c:InsertBlocksArchiPC9 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc9")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((27224 35750 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC9 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC9' to run the program.")
(princ)



; Define the main function
(defun c:InsertBlocksArchiPC10 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc10")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((27909 40113 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC10 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC10' to run the program.")
(princ)




; Define the main function
(defun c:InsertBlocksArchiPC11 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc11")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((17675 7440 300)
        (17675 17760 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC11 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC11' to run the program.")
(princ)






; Define the main function
(defun c:InsertBlocksArchiPC12 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc12")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((5597 7440 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC12 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC12' to run the program.")
(princ)






; Define the main function
(defun c:InsertBlocksArchiPC13 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc13")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((17675 312 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC13 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC13' to run the program.")
(princ)




; Define the main function
(defun c:InsertBlocksArchiPC14 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc14")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((2078 26288 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC14 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC14' to run the program.")
(princ)





; Define the main function
(defun c:InsertBlocksArchiPC15 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc15")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((30732 15933 300)
        (32778 15898 300)
        (30732 17875 300)
))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC15 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC15' to run the program.")
(princ)




; Define the main function
(defun c:InsertBlocksArchiPC16 (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name "pc16")
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((32778 17875 300)))

      ; Loop through each item in the list
      (foreach item coord-list
        (setq x (car item))         ; X coordinate
        (setq y (cadr item))        ; Y coordinate
        (setq z (caddr item))       ; Z coordinate

        ; Debug messages for coordinates
        (princ (strcat "\nInserting block at coordinates: (" (rtos x) ", " (rtos y) ", " (rtos z) ")"))

        ; Insert the block at the specified coordinates using -INSERT for more control
        (command "_.-INSERT" block-name (list x y z) "1" "1" "0")
      )
    )
    (princ "\nInvalid block name or block does not exist in the drawing.")
  )

  (princ "\nInsertBlocksArchiPC16 function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchiPC16' to run the program.")
(princ)

