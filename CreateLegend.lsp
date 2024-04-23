(defun c:CreateLegend ()
  (vl-load-com)

  (defun GetAllLayers ()
    (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
    (setq layers (vla-get-Layers doc))
    (setq layerList '())

    (vlax-for layer layers
      (setq name (vla-get-Name layer))
      (setq color (itoa (vla-get-Color layer)))
      (setq lw (rtos (* 0.01 (vla-get-LineWeight layer))))
      (setq desc (vla-get-Description layer))
      (setq layerProps (list name desc color lw))
      (setq layerList (cons layerProps layerList))
    )
    (reverse layerList)
  )
  ;; Legend Drawing Function
  (defun DrawLegend (layerList)
     (setq yPos 0)

    (foreach layer layerList
      (setq layerName (car layer))
      (setq description (cadr layer))
      (setq color (caddr layer))
      (setq lineweight (cadddr layer))

      ;; Draw Layer Name
      (command "_.TEXT" (strcat "0," (rtos yPos) ",0") "0.2" "0" layerName)

      ;; Draw Description
      (command "_.TEXT" (strcat "5," (rtos yPos) ",0") "0.2" "0" description)

      ;; Draw Color
      (command "_.TEXT" (strcat "10," (rtos yPos) ",0") "0.2" "0" color)

      ;; Set the current layer for the line
      (command "_.LAYER" "_S" layerName "")
      ;; Draw Line representing the layer
      (command "_.LINE" (strcat "15," (rtos yPos) ",0") (strcat "20," (rtos yPos) ",0") "")
      (setq yPos (- yPos 0.75))  ; Adjust yPos for spacing between layers
    )
  )

    ;; Main Execution
  (setq allLayers (GetAllLayers))
  (DrawLegend allLayers)

  (princ)
)

;; Run the Function
(c:CreateLegend)
(princ)
