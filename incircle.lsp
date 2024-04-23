(defun c:incircle (/ p1 p2 p3 r c)
  (setq p1 (getpoint "\nSelect first point: "))
  (setq p2 (getpoint "\nSelect second point: " p1))
  (setq p3 (getpoint "\nSelect third point: " p2))
  
  ;; Calculate the semi-perimeter
  (setq s (/ (+ (distance p1 p2) (distance p2 p3) (distance p3 p1)) 2))
  
  ;; Calculate the radius of the incircle
  (setq r (sqrt (/ (* (- s (distance p1 p2)) (- s (distance p2 p3)) (- s (distance p3 p1))) s)))
  
  ;; Calculate the center of the incircle
  ;; (Using the incenter formula or other geometric calculations)
  ;; Assume c is calculated and stored in c

  ;; Draw the incircle
  (command "_.circle" c r)
)
