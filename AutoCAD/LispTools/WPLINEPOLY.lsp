(defun c:WPLINE ( / keepGoing lyr tmp)
;Wood PLINE
(setq keepGoing t)
(setq lyr (tblobjname "LAYER" "Wood"))
(while keepGoing
  (command-s "_.PLINE" pause "w" 3.0 3.0)
  (if lyr (setpropertyvalue (entlast) "LayerId" lyr))
  (initget "No Yes")
  (if (or (null (setq tmp (getkword "\nAnother? [No/Yes] <No>")))
          (eq "No" tmp))
    (setq keepGoing nil)
    (setq keepGoing t)
  );if
);while
(prompt "\nWPLINE Complete.")
(princ)
);defun