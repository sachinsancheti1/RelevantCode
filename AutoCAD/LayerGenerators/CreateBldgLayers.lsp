(defun c:CreateBldgLayers ()
  (vl-load-com)

  (defun CreateLayer (layerName color lineweight description)
    (setq lw (vl-string-translate "mm" "" lineweight)) ; Remove 'mm' from the lineweight string
    (setq lw (atof lw)) ; Convert lineweight to a real number
    (setq lw (* lw 100)) ; Convert mm to AutoCAD's internal units (hundredths of millimeters)

    ;; Create the layer
    (vla-add (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object))) layerName)
    (setq layerObj (vla-item (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object))) layerName))

    ;; Set layer properties
    (vla-put-Color layerObj (atoi color))
    (vla-put-LineWeight layerObj lw)
    (vla-put-Description layerObj description)
  )

  ;; Creating Building Floor Plan Layers with descriptions
  (CreateLayer "A-WALL-EXT" "8" "0.50" "Exterior Walls")
  (CreateLayer "A-WALL-STRC" "8" "0.40" "Load-Bearing Walls")
    (CreateLayer "A-WALL-PART" "8" "0.35" "Partition Walls")
  (CreateLayer "A-WALL-FURR" "8" "0.25" "Furred or Thin Walls")

  ; Doors and Windows
  (CreateLayer "A-DOOR" "5" "0.35" "Doors")
  (CreateLayer "A-DOOR-MAIN" "5" "0.35" "Main Entrance Doors")
  (CreateLayer "A-DOOR-INT" "5" "0.30" "Interior Doors")
  (CreateLayer "A-WIND" "5" "0.25" "Windows")

  ; Furniture and Fixtures
  (CreateLayer "A-FURN-FIXT" "6" "0.25" "Built-in Furniture and Fixtures")
  (CreateLayer "A-FURN-LOOSE" "6" "0.18" "Loose Furniture")
  (CreateLayer "A-FIXT-PLUMB" "6" "0.18" "Plumbing Fixtures")

  ; Flooring
  (CreateLayer "A-FLOR" "3" "0.25" "Flooring Patterns")
  (CreateLayer "A-FLOR-TILE" "3" "0.25" "Tiled Areas")
  (CreateLayer "A-FLOR-CARP" "3" "0.25" "Carpeted Areas")

  ; Ceiling Details
  (CreateLayer "A-CEIL" "151" "0.15" "Ceiling Plan")
  (CreateLayer "A-CEIL-GRID" "151" "0.15" "Ceiling Grids")
  (CreateLayer "A-CEIL-LITE" "151" "0.18" "Lighting Fixtures")

  ; Text and Dimensions
  (CreateLayer "A-ANNO-TEXT" "4" "0.15" "Text and Labels")
  (CreateLayer "A-ANNO-DIM" "2" "0.15" "Dimensions")

  ; Other Details
  (CreateLayer "A-ELEC" "30" "0.15" "Electrical Layout")
  (CreateLayer "A-HVAC" "30" "0.18" "HVAC Layout")

  (princ)
)
(c:CreateBldgLayers)
(princ)