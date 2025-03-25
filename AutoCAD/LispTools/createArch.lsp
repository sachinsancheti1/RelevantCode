(defun c:CreateArch (/ spanLine spanPt1 spanPt2 basePoint span height R c O1 u O2 O3)

  ; Function to get the midpoint of a line
  (defun MidPoint (p1 p2)
    (mapcar '/ (mapcar '+ p1 p2) '(2 2 2))
  )

  ; Ask user to select or draw the span line
  (setq spanLine (entsel "\nSelect or draw the span line: "))
  (setq spanPt1 (cdr (assoc 10 (entget (car spanLine)))))
  (setq spanPt2 (cdr (assoc 11 (entget (car spanLine)))))

  ; Calculate the midpoint of the span (basePoint)
  (setq basePoint (MidPoint spanPt1 spanPt2))

  ; Calculate the span distance
  (setq span (distance spanPt1 spanPt2))

  ; Ask user to input the height
  (setq height (getdist "\nEnter the height: "))

  ; Calculate R for circle O1
  (setq R (/ (+ (expt span 2) (expt height 2) (* (- span height) (sqrt (+ (expt span 2) (expt height 2)))))
             (* 2 span)))

  ; Calculate c for circle O1 (which is R - height)
  (setq c (- R height))

  ; Calculate u for circles O2 and O3
  (setq u (/ (+ (expt span 2) (expt height 2) (* (- height span) (sqrt (+ (expt span 2) (expt height 2)))))
             (* 2 span)))

; Calculate alpha
  (setq alpha (/ (+ (/ span 2) height (- (sqrt (+ (expt (/ span 2) 2) (expt height 2))))) 2))
  
  ; Calculate O1 by moving down R - height on the Y-axis
  (setq O1 (list (car basePoint) (- (cadr basePoint) c)))

  ; Calculate O2 by moving u to the left on the X-axis
  (setq O2 (list (- (car basePoint) (- (/ span 2) u)) (cadr basePoint)))

  ; Calculate O3 by moving u to the right on the X-axis
  (setq O3 (list (+ (car basePoint) (- (/ span 2) u)) (cadr basePoint)))

  ; Create circle O4 at basePoint
  (setq O4 basePoint)

  ; Debugging: Print O2 center
  (princ (strcat "\nBase Point: " (vl-princ-to-string basePoint)))
  (princ (strcat "\nValue of u: " (vl-princ-to-string u)))

   (princ (strcat "\nCenter of O2: " (vl-princ-to-string O2)))


  ; Create the first circle at O1 with radius R
  (command "_.circle" O1 R)

  ; Create the second circle at O2 with radius u
  (command "_.circle" O2 u)

  ; Create the third circle at O3 with radius u
  (command "_.circle" O3 u)

  ; Create the third circle at O4 with radius alpha
  (command "_.circle" O4 alpha)

  ; Print message about the fillet size
  (princ (strcat "\nPlease fillet of the arch corners after finding intersection to have to be: " (vl-princ-to-string alpha)))


  (princ)
)
