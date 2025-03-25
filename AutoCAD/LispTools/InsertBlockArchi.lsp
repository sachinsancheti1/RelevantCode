; Define the main function
(defun c:InsertBlocksArchi (/ block-name block-ref item x y z)
  (princ "\nInsertBlocks function started.") ; Debug message
  
  ; Ask the user to select a block from the drawing
  (setq block-name (getstring "\nEnter block name: "))
  
  ; Check if the block name is valid
  (if (and block-name (tblsearch "BLOCK" block-name))
    (progn
      ; Define the list of coordinates
      ; Format: ((x y z) ...)
      (setq coord-list '((43025 17950 300) (32425 32264 300) (26757 15683 300) 
(26617 22922 300) (17712.5 22962 300) (41107 35600 300) (5522 12600 300)))

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

  (princ "\nInsertBlocksArchi function completed.") ; Debug message
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocksArchi' to run the program.")
(princ)
