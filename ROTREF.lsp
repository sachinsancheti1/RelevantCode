(defun c:ROTREF (/)
   (graphscr)
   (terpri)
   (setq ENTROT NIL)
   (princ "\n ")
   (princ "\n              SELECT ENTITY TO RE-ROTATE: ")
   (setq RRENT (entsel "\n "))
   (setq VERBRT "REFERENCE: ")
   (GETRT)
   (if (and (boundp 'RRENT) (boundp 'ROT))
      (progn (setq RRENTNM (car RRENT))
             (setq ROTTYPE (cdr (assoc 0 (entget RRENTNM))))
             (cond ((or (= ROTTYPE "INSERT") (= ROTTYPE "TEXT") (= ROTTYPE "MTEXT"))
                    (if (or (= ROTTYPE "INSERT") (= ROTTYPE "MTEXT"))
                       (setq ENTPT (cdr (assoc 10 (entget RRENTNM))))
                       (progn (TESTTEXT RRENTNM) (setq ENTPT TXTCTR))
                    )
                    (setq ROTRT (RTD (cdr (assoc 50 (entget RRENTNM)))))
                    (command "rotate" RRENTNM "" ENTPT "r" ROTRT ROT)
                    (command "MOVE" RRENTNM "" ENTPT PAUSE)
                   ) ; close progn
                   ((or (= ROTTYPE "LINE") (= ROTTYPE "PLINE"))
                    (princ "\n ")
                    (princ "\n              SELECT ENTITY TO RE-ROTATE: ")
                    (setq ENTPT (getpoint "\n "))
                    (command "rotate" RRENTNM "" ENTPT "r" ROTRT ROT)
                    (command "move" RRENTNM "" ENTPT PAUSE)
                   ) ; close progn
             ) ; close cond
      )   ; close progn  
   )      ; close if
   (princ)
)         ; END FUNCTION