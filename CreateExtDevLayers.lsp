(defun c:CreateExtDevLayers ()
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

  ; Creating Layers for External Development
  (CreateLayer "A-ROAD-MAJR" "8" "0.50" "Major Roads")
  (CreateLayer "A-ROAD-MINR" "8" "0.35" "Minor Roads/Lanes")

  (CreateLayer "A-DRAN-OPEN" "5" "0.30" "Open Drains")
  (CreateLayer "A-DRAN-UNDR" "5" "0.25" "Underground Drains")

  (CreateLayer "A-PARK-CVRD" "2" "0.30" "Covered Parking")
  (CreateLayer "A-PARK-OPEN" "30" "0.25" "Open Car Parking")

  (CreateLayer "A-PATH-MAJR" "6" "0.30" "Major Paths")
  (CreateLayer "A-PATH-MINR" "6" "0.25" "Minor Paths")

  (CreateLayer "A-ELEC-DUCT" "1" "0.25" "Electrical Ducts")
  (CreateLayer "A-ELEC-OVRH" "1" "0.18" "Overhead Electrical Lines")
  (CreateLayer "A-ELEC-UNDR" "1" "0.18" "Underground Electrical Lines")

  (CreateLayer "A-UTIL-STP" "210" "0.30" "Sewage Treatment Plants")
  (CreateLayer "A-UTIL-WTANK" "210" "0.30" "Water Tanks (UG and Overhead)")
  (CreateLayer "A-UTIL-TRNSF" "210" "0.30" "Transformers")

  (CreateLayer "A-CURB" "8" "0.25" "Curb Stones")
  (CreateLayer "A-WALL-RETN" "7" "0.40" "Retention Walls")
  (CreateLayer "A-WALL-RCC" "7" "0.35" "RCC Walls")

  (CreateLayer "A-LAND-VEG" "3" "0.25" "Trees, Shrubs, Gardens")
  (CreateLayer "A-LAND-LITE" "151" "0.25" "Lighting Posts, Benches")

  (CreateLayer "A-SIGN-DIR" "4" "0.25" "Directional Signage")
  (CreateLayer "A-SIGN-INFO" "4" "0.18" "Informational Signage")

  (CreateLayer "A-SAFE-HYDR" "1" "0.25" "Fire Hydrants")
  (CreateLayer "A-SAFE-SEC" "1" "0.20" "Security Cameras")

  (CreateLayer "A-UTIL-GAS" "30" "0.25" "Gas Lines")
  (CreateLayer "A-UTIL-TELC" "210" "0.18" "Telecommunication Lines")

  (CreateLayer "A-ENV-WATER" "5" "0.30" "Water Features")
  (CreateLayer "A-ENV-EROS" "5" "0.30" "Erosion Control Structures")

  (CreateLayer "A-ACCS-RAMP" "2" "0.30" "Ramps")
  (CreateLayer "A-ACCS-TACT" "2" "0.25" "Tactile Paving")

  (CreateLayer "A-TRFC-SIGN" "1" "0.25" "Traffic Management Signs")
  (CreateLayer "A-TRFC-CROSS" "7" "0.25" "Pedestrian Crosswalks")

  (CreateLayer "A-GEN-SCAL" "0" "0.20" "Scale Bar")
  (CreateLayer "A-GEN-NORTH" "0" "0.20" "North Symbol")

  (CreateLayer "A-CONS-FOOT" "6" "0.35" "Footings and Foundations")
  (CreateLayer "A-CONS-DRAIN" "6" "0.30" "Drainage and Grading Plans")

  (princ)
)
(c:CreateExtDevLayers)
(princ)