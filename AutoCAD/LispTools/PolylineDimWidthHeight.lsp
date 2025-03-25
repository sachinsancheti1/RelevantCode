(defun c:UpdateTableWithPolylineDims ()
  (setq pline (car (entsel "\nSelect polyline: ")))
  (if (and pline (= (cdr (assoc 0 (entget pline))) "LWPOLYLINE"))
    (progn
      (setq vertices (c:FindVertices_ pline))
      (princ "\nVertices: ")
      (princ vertices)

      (setq maxWidth (- (maxX vertices) (minX vertices)))
      (setq maxHeight (- (maxY vertices) (minY vertices)))
      (setq area (/ (* maxWidth maxHeight) 1000000)) ; Calculate the area

      (princ "\nMax Width: ")
      (princ maxWidth)
      (princ "\nMax Height: ")
      (princ maxHeight)

      (setq tableEntRes (entsel "\nSelect table: "))
      (if (not tableEntRes)
        (princ "\nInvalid selection or cancelled.")
        (progn
          (setq tableEnt (car tableEntRes))
          (setq table (vlax-ename->vla-object tableEnt))  ; Convert entity to VLA object
          (setq row (getint "\nEnter row number: "))
          (setq col 1)

          (setq custText (getstring "\nEnter Board Number "))

          (setq centroid (CalculateCentroid vertices))
          (AddTextAtPoint custText centroid)
          (princ centroid)
          (princ custText)
          (princ "\nText added at centroid on layer 'A_Walls_Annotation'.")
          
          (updateTableCell table row col maxWidth maxHeight area custText)
        )
      )
    )
    (princ "\nNot a valid polyline.")
  )
  (princ)
)

(defun maxX (vertices)
  (apply 'max (mapcar 'car vertices))
)

(defun maxY (vertices)
  (apply 'max (mapcar 'cadr vertices))
)

(defun minX (vertices)
  (apply 'min (mapcar 'car vertices))
)

(defun minY (vertices)
  (apply 'min (mapcar 'cadr vertices))
)

(defun CalculateCentroid (vertices)
  (setq sumX 0 sumY 0 n (length vertices))
  (foreach vertex vertices
    (setq sumX (+ sumX (car vertex)))
    (setq sumY (+ sumY (cadr vertex)))
  )
  (list (/ sumX n) (/ sumY n)) ; Return the centroid as a list [x, y]
)


(defun AddTextAtPoint (custText centroid / mtextEntity)
  ; Define the MText entity
  (setq mtextEntity
    (list
      '(0 . "MTEXT")               ; Entity type
      (cons 10 centroid)              ; Insertion point
      '(40 . 25)                  ; Text height
      (cons 1 custText)          ; The string to print
      '(71 . 1)                    ; Attachment point (1 = Top Left)
      '(72 . 1)                    ; Drawing direction (1 = Left to Right)
    )
  )

  (entmake mtextEntity)            ; Create the MText entity
  (princ"\nCreated Text in Polyline Centre")
)


(defun updateTableCell (table row col maxWidth maxHeight area custText)
  (if (and (vlax-write-enabled-p table) 
           (>= row 0) 
           (>= col 0))
    (progn
      ; Set text directly in the specified cell
      (vlax-invoke-method table 'SetText row col (strcat "Max W: " (rtos maxWidth)))
      (vlax-invoke-method table 'SetText row (+ col 1) (strcat "Max H: " (rtos maxHeight)))
      (vlax-invoke-method table 'SetText row (+ col 2) (strcat "Area: " (rtos area)))
      (vlax-invoke-method table 'SetText row (+ col 3) custText)
    )
    (princ "\nInvalid table, row, or column.")
  )
)

(princ "\nType 'UpdateTableWithPolylineDims' to run the program.")


(defun c:FindVertices ()
  (setq pline (car (entsel "\nSelect a polyline: ")))  ; Select the polyline
  (setq plineObj (vlax-ename->vla-object pline))       ; Convert to VLA object
  (setq startParam (vlax-curve-getStartParam plineObj))
  (setq endParam (vlax-curve-getEndParam plineObj))

  (while (<= startParam endParam)
    (setq vertex (vlax-curve-getPointAtParam plineObj startParam))
    (princ (strcat "\nVertex: " (vl-princ-to-string vertex)))
    (setq startParam (+ startParam 1))
  )
  (princ)
)

(defun c:FindVertices_ (pline)
  (setq plineObj (vlax-ename->vla-object pline))       ; Convert to VLA object
  (setq vertices '())                                  ; Initialize an empty list for vertices
  (setq startParam (vlax-curve-getStartParam plineObj))
  (setq endParam (vlax-curve-getEndParam plineObj))

  (while (<= startParam endParam)
    (setq vertex (vlax-curve-getPointAtParam plineObj startParam))
    (setq vertices (cons vertex vertices))             ; Add vertex to list
    (setq startParam (+ startParam 1))
  )
  vertices                                             ; Return the list of vertices
)