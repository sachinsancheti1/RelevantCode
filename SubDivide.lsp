;;  SubDivide.lsp [command name: SD]
;;  To SubDivide a finite linear object into a specified
;;    number of equal-length contiguous sections.
;;  Option: numerical quantity of sections, or Maximum
;;    length of sections, however many are required.
;;  Can also place Points at subdivision locations, if
;;    desired [see commented-out Divide command].
;;  Remembers choices and offers as defaults.
;;  Works on anything of finite length that Break can
;;    be used on [not Xlines or Rays].
;;  Kent Cooper, last edited September 2011
;
(defun C:SD
  (/ *error* subdiv obj cmde blips osm esel ent etype
  entlen secdef sectemp maxtemp secs seclen ent2 secs1 secs2)
;
  (defun *error* (errmsg)
    (if (not (wcmatch errmsg "Function cancelled,quit / exit abort,console break"))
      (princ (strcat "\nError: " errmsg))
    ); end if
    (setvar 'osmode osm)
    (setvar 'blipmode blips)
    (command "_.undo" "_end")
    (setvar 'cmdecho cmde)
  ); end defun *error*
;
  (defun subdiv (obj brks)
    (repeat brks
      (command
        "_.break"
        obj
        (trans (vlax-curve-getPointAtDist obj seclen) 0 1)
        "@"
      ); end command
      (setq obj (entlast))
    ); end repeat
  ); end defun - subdiv
;
  (vl-load-com)
  (setq cmde (getvar 'cmdecho))
  (setvar 'cmdecho 0)
  (command "_.undo" "_begin")
  (setq
    blips (getvar 'blipmode)
    osm (getvar 'osmode)
  ); end setq
;
  (while
    (not
      (and
        (setq esel (ssget ":S" '((0 . "LINE,ARC,CIRCLE,*POLYLINE,ELLIPSE,SPLINE"))))
        (= (cdr (assoc 70 (tblsearch "layer" (cdr (assoc 8 (entget (ssname esel 0))))))) 0)
          ; 0 for Unlocked, 4 for Locked
      ); end and
    ); end not
    (prompt "\nNothing selected, or not a finite path type, or on a Locked Layer; try again:")
  ); end while
  (setvar 'osmode 0)
  (setvar 'blipmode 0)
  (setq
    ent (ssname esel 0)
    etype (if ent (cdr (assoc 0 (entget ent))))
    entlen (vlax-curve-getDistAtParam ent (vlax-curve-getEndParam ent))
  ); end setq
;
  (initget 6 "Maximum"); no zero, no negative
  (setq
    secdef (if _sdsec_ _sdsec_ "Maximum")
      ; once set, _sdsec_ is either integer or "Maximum" [first-use default]
    sectemp
      (getint ; [returns nil on Enter]
        (strcat
          "\nEnter number of Sections, or M for Maximum length <"
          (if (numberp secdef); if default is a number,
            (itoa secdef); then - text equivalent
            secdef ; else - it's "Maximum"; use it
          ); end if
          ">: "
        ); end strcat
      ); end getint and sectemp
    _sdsec_ (if sectemp sectemp secdef)
      ; what User typed if other than Enter - if Enter, use default
  ); end setq
  (if (= _sdsec_ "Maximum")
    (while
      (not
        (and
          (progn
            (if _sdmax_ (initget 38) (initget 39)); returns nil, so need (progn) wrapper
              ; no Enter on first use, no 0, no negative, dashed rubber-band if picked on-screen
            (setq
              maxtemp
                (getdist
                  (strcat
                    "\nMaximum length of Sections"
                    (if _sdmax_ (strcat " <" (rtos _sdmax_) ">") ""); no default on first use
                    ": "
                  ); end strcat
                ); end getdist & maxtemp
              _sdmax_ (cond (maxtemp) (_sdmax_))
                ; if User typed/picked something other than Enter, then - use it; else - default
            ); end setq
          ); end progn
          (<= _sdmax_ entlen); Maximum length shorter than or equal to length of object
        ); end and
      ); end not
      (prompt "\nObject is no longer than Maximum length.")
    ); end while
  ); end if
  (setq secs
    (if (numberp _sdsec_)
      _sdsec_ ; then [number]
      (if (zerop (rem entlen _sdmax_)); else [Maximum]
        (fix (/ entlen _sdmax_))
        (1+ (fix (/ entlen _sdmax_)))
      ); end if and else
    ); end if
    seclen (/ entlen secs)
  ); end setq
;
;  (command "_.divide" ent secs) ; remove leading semicolon and this comment if Points are desired along with subdivision
  (cond
    ( ; Circle or closed Ellipse/Spline [can't break at one point]
      (and (wcmatch etype "CIRCLE,ELLIPSE,SPLINE") (vlax-curve-isClosed ent))
      (command "_.copy" ent "" "0,0" "0,0"); make a copy in place
      (setq
        ent2 (entlast)
        secs1 (/ secs 2)
        secs2 (- secs secs1)
      ); end setq
      (command
        "_.break"
        ent
        (trans (vlax-curve-getStartPoint ent) 0 1)
        (trans (vlax-curve-getPointAtDist ent (* seclen secs1)) 0 1)
        "_.break"
        ent2
        (trans (vlax-curve-getPointAtDist ent2 (* seclen secs1)) 0 1)
        (trans (vlax-curve-getStartPoint ent2) 0 1)
      ); end command
      (subdiv ent (1- secs2))
      (subdiv ent2 (1- secs1))
    ); end Circle or closed Ellipse/Spline condition
    (T ; everything else
      (subdiv ent (1- secs))
    ); end everything-else condition
  ); end cond
;
  (setvar 'osmode osm)
  (setvar 'blipmode blips)
  (command "_.undo" "_end")
  (setvar 'cmdecho cmde)
  (princ)
); end defun
(prompt "Type SD to SubDivide a linear object.")
