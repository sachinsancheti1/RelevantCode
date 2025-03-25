(defun c:OffsetClosedPolylinesToPoint ()
  (setq offsetDistance 50)  ; Set the offset distance
  (setq ss (ssget "X" '((0 . "LWPOLYLINE"))))  ; Select all polylines in the drawing
  (setq point (getpoint "\nSelect point for offset direction: "))  ; Get the point for offset direction
  (if (and ss point)
    (progn
      (setq n (sslength ss))  ; Get the number of selected polylines
      (repeat n
        (setq ent (ssname ss (setq n (1- n))))  ; Get the entity name of each polyline
        (setq entData (entget ent))  ; Get the entity data
        (if (= (cdr (assoc 70 entData)) 1)  ; Check if the polyline is closed
          (progn
            (command "_.offset" offsetDistance ent "")  ; Offset the polyline outward
            (setq offsetPolyline (entlast))  ; Get the newly created offset polyline
          )
        )
      )  ; End repeat
    )  ; End progn
  )  ; End if
  (princ)  ; End the function without returning any value
)
