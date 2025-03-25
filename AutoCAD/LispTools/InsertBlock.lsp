; Define the main function
(defun c:InsertBlocks (/ block-name block-ref item x y z)
  ; Ask the user to select a block from the drawing
  (setq block-name (getstring "\nEnter block name: "))
  
  ; Define the list of coordinates
  ; Format: ((x y z) ...)
  (setq coord-list '((12305 -3781 0) (32669 -3781 0) (15699 -3781 0)
                     (19093 -3781 0) (22487 -3781 0) (25881 -3781 0)
                     (29275 -3781 0) (51583 237 0) (36179 237 0)
                     (237 237 0) (8795 237 0) (12305 237 0)
                     (39602 237 0) (43025 237 0) (46448 237 0)))

  ; Loop through each item in the list
  (foreach item coord-list
    (setq x (car item))         ; X coordinate
    (setq y (cadr item))        ; Y coordinate
    (setq z (caddr item))       ; Z coordinate

    ; Insert the block at the specified coordinates
    (command "_.INSERT" block-name x y z 1 1 0)
  )
  
  (princ) ; Clean exit
)

; Activate the function
(princ "\nType 'InsertBlocks' to run the program.")
(princ)