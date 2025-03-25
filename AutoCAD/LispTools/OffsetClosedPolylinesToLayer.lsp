(defun c:OffsetClosedPolylinesToLayer ()
  (setq offsetDistance 100)  ; Set the offset distance
  (setq layerName "S-Excavation-Box-Outer")  ; Set the target layer name

  ; Ensure the target layer exists
  (if (not (tblsearch "LAYER" layerName))
    (progn
      (command "_.layer" "M" layerName "")
      (princ (strcat "\nLayer " layerName " created."))
    )
    (princ (strcat "\nLayer " layerName " already exists."))
  )

  (setq ss (ssget "X" '((0 . "LWPOLYLINE"))))  ; Select all polylines in the drawing
  (if ss
    (progn
      (setq n (sslength ss))  ; Get the number of selected polylines
      (princ (strcat "\nNumber of polylines selected: " (itoa n)))
      (repeat n
        (setq ent (ssname ss (setq n (1- n))))  ; Get the entity name of each polyline
        (setq entData (entget ent))  ; Get the entity data
        (if (= (cdr (assoc 70 entData)) 1)  ; Check if the polyline is closed
          (progn
            (princ (strcat "\nOffsetting polyline: " (cdr (assoc 5 entData))))
            (command "_.offset" offsetDistance ent "")  ; Offset the polyline outward
            (setq offsetPolyline (entlast))  ; Get the newly created offset polyline
            (if offsetPolyline
              (progn
                (princ (strcat "\nNew offset polyline: " (cdr (assoc 5 (entget offsetPolyline)))))
                (command "_.chprop" offsetPolyline "" "LA" layerName "")  ; Change the layer of the offset polyline
                (princ (strcat "\nChanged layer to: " layerName))
              )
              (princ "\nFailed to create offset polyline.")
            )
          )
          (princ "\nPolyline is not closed.")
        )
      )  ; End repeat
    )  ; End progn
    (princ "\nNo polylines found.")
  )  ; End if
  (princ)  ; End the function without returning any value
)
