(defun c:CreateLeadersWithCounter (/ ss i ent pt counter)
    ; Initialize the counter
    (setq counter 1)
    ; Start the function
    (princ "\nSelect objects for which to create leaders: ")
    ; Allow the user to select objects
    (setq ss (ssget))
    ; Check if selection is not null
    (if ss
        (progn
            ; Loop through each object in the selection
            (setq i 0)
            (repeat (sslength ss)
                ; Get each entity
                (setq ent (ssname ss i))
                ; Get a point for the leader
                (setq pt (getpoint "\nSpecify leader point: "))
                (setq newX (+ (car pt) 10))   ; Add 10 to the X coordinate
                (setq newY (- (cadr pt) 10))  ; Subtract 10 from the Y coordinate
                (setq newPt (list newX newY)) ; Create a new point with the updated coordinates
                ; Create the leader with text
                (command "MLEADER" "_P" pt newPt (strcat "B" (itoa counter)))
                ; Increment the counter
                (setq counter (1+ counter))
                (setq i (1+ i))
            )
        )
    )
    (princ)
)
