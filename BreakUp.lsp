;;  BREAKUP Commands for AutoCAD Linetypes---------UNDER CONSTRUCTION
;;  BreakUp.lsp [command names: BU- followed by linetype name]
;;  Kent Cooper, last edited June 2011
;;
;;  To Break Up linear entities into separate short entities and gaps, and/or add points
;;    where appropriate, to emulate the appearance of non-continuous linetypes.
;;  With closed objects, must check for entity type, because:  After one break of Circle or
;;    closed Ellipse/Spline/LWPolyline, remaining object retains original entity name but
;;    may not be (entlast).  But with "heavy" 2D or 3D Polyline, remaining object(s) [on both
;;    sides of break if appropriate] get(s) *new* entity name(s) [original(s) is/are lost], and
;;    downstream portion from break [if present; upstream otherwise] is always (entlast).
;;  Entity-type- and linetype-specific notes:
;;    ["2D" in relation to Polylines always refers to "heavy" 2D Polylines.]
;;    1.  In closed 2D/LW Polylines, linetype cycle in display does not begin at start/end
;;    point (1st vertex, parameter 0), but at 2nd vertex (parameter 1).  Routines break objects
;;    to conform to that.
;;    2.  Routines process 2D/LW Polylines as if linetype generation is enabled, whether
;;    or not it is for a given object or in the drawing for new Polylines. To emulate disabled
;;    linetype generation, explode Polyline(s) first, and process the resulting Lines/Arcs.
;;    3.  3DPolylines *do not* honor non-continuous linetypes in display.  Routines use a
;;    segment beginning from start point of closed ones (like Circle, but unlike 2D & LW
;;    Polylines), because it's easier; can't match appearance of non-Broken-Up one anyway.
;;    4.  Closed Ellipses/Splines with non-continuous linetypes *do not* divide evenly in
;;    display, but can have unequal-length dash segment straddling start point (apparently
;;    treat cycle as with open-ended objects, not adjusting dash/gap sizes as with Circles/
;;    closed Polylines, but adjusting ends); routines regularize that, dividing overall length
;;    evenly with adjusted dash/gap sizes, but retain centering of segment around start
;;    point characteristic of displayed whole objects.
;;    5.  Dot family linetypes display dots at defined-gap spacing for certain objects, equal
;;    adjusted spacing for certain [but not all] closed objects, and with peculiarities at ends
;;    of some curved objects, in some cases affected by Zoom level.  Routines use adjusted
;;    equal spacing throughout for all objects.

;;;;   SO FAR:
;;;;   1.  does not account for different coordinate systems;
;;;;   2.  except in Dot family routines, leaves alone the linetype of an object's Layer, or any
;;;;        override linetype on the object [e.g., a Line with a short-cycle linetype such as
;;;;        HIDDEN2, either through its Layer or as an override, broken up with a long-cycle
;;;;        routine such as BU-DASHEDX2, will result in Lines of DashedX2 dash length that
;;;;        still have HIDDEN2 linetype, displaying segmented into 6 pieces in that case];
;;;;   3.  ignores any linetype scale overrides on selected items, and breaks up into
;;;;        segments sized for linetype scale of 1 relative to drawing's LTSCALE setting.
;;;;   Possible enhancements to come:
;;;;   In linetypes with Dots, what about Plines with width?  Insert perpendicular Line with length = Pline width ?
;;;;   Overall test for too-shortness before even doing first-cycle break(s)?
;;;;   Linetype-generic option to break up according to object's/layer's linetype [& scale?] ?

;; ------------------ Preliminaries and shared sub-routines ------------------

(vl-load-com)

(defun lts (num)
  (* (getvar 'ltscale) num)
); end defun - lts

(defun BU-common ()
  (defun *error* (errmsg)
    (if (not (wcmatch errmsg "Function cancelled,quit / exit abort,console break"))
      (princ (strcat "\nError: " errmsg))
    ); end if
    (command)
    (command)
    (BU-reset)
  ); end defun - *error*
  (setq cmde (getvar 'cmdecho))
  (setvar 'cmdecho 0)
  (command "_.undo" "_begin")
  (setq
    osm (getvar 'osmode)
    clay (getvar 'clayer);;;;do this only in families with dots?
    blipm (getvar 'blipmode)
  ); end setq
  (setvar 'osmode 0)
  (prompt (strcat "To Break Up objects to emulate " BU-lt " linetype,"))
  (setq BU-sel (ssget '((0 . "LINE,ARC,CIRCLE,ELLIPSE,*POLYLINE,SPLINE"))))
  (setvar 'blipmode 0)
); end defun - BU-common

(defun BU-entlen (obj)
  (vlax-curve-getDistAtParam obj (vlax-curve-getEndParam obj))
); end defun - BU-entlen

(defun BU-entinfo (/ edata cycleratio); common to all commands
  (setq
    brkent (ssname BU-sel 0)
    unlk (= (cdr (assoc 70 (tblsearch "layer" (cdr (assoc 8 (entget brkent)))))) 0)
      ;; object is on unlocked Layer
  ); end setq
  (if unlk
    (progn - unlocked Layer
      (setq
        edata (entget brkent)
        etype (substr (cdr (assoc 100 (cdr (member (assoc 100 edata) edata)))) 5)
          ;; *second* 100 value minus "AcDb" prefix, to distinguish Polyline types
        closed (vlax-curve-isClosed brkent)
        entlen (BU-entlen brkent)
        elay (cdr (assoc 8 edata));;;;do this only in families with dots, and remove clay/elay localized variables from no-dot families?
      ); end setq
      (if closed
        (progn ; then - closed object
          (setq
            cycles (fix (+ (/ entlen cycle) 0.5)); rounded up or down
            ;; change dash and gap sizes to divide equally into overall length:
            cycleratio (/ (setq ecycle (/ entlen cycles)) cycle)
            edash (if dash (* dash cycleratio)); dash [or longer dash] size for this entity
            edash2 (if dash2 (* dash2 cycleratio)); dash2 [if present] size for this entity
            egap (* gap cycleratio); gap size for this entity
          ); end setq
          (if (and (wcmatch etype "Polyline,2dPolyline") closed)
            ;; end/start of a cycle at parameter 1 [2nd vertex], for some reason
            (setq seg1len (vlax-curve-getDistAtParam brkent 1))
          ); end if - LW/2DPoly
        ); end progn - then - closed object
      ); end if - closed
      (if (/= (substr BU-lt 1 3) "DOT")
        ;; entities-with-dashes further cycle info, for all except Dot family
        (progn ; then
          (if (not closed)
            (setq ; open-ended object
              brklen (- entlen dash)
              overage (rem entlen cycle)
              cycles
                (if (< overage dash)
                  (1+ (fix (/ brklen cycle)))
                  (fix (/ brklen cycle))
                ); end if & cycles
              extra (/ (- overage dash) 2); [can be negative]
            ); end setq - else - open-ended object
          ); end if - open-ended object
          (setq cycles (1- cycles))
            ;; reduced by 1 for all non-DOT types [1st break cycle not within (repeat cycles...)]
        ); end progn - then - other than DOT family
      ); end if - other than DOT family
    ); end progn - then - on unlocked Layer
  ); end if - unlocked [no else argument for locked Layer - do nothing]
); end defun - BU-entinfo

(defun BU-brk (obj d1 d2)
  (command
    "_.break" obj
    (vlax-curve-getPointAtDist obj d1)
    (vlax-curve-getPointAtDist obj d2)
  ); end command
); end defun - BU-brk

(defun BU-pt (obj dist)
  (command
    "_.point"
    (vlax-curve-getPointAtDist obj dist)
  ); end command
); end defun - BU-pt

(defun BU-brkEnd-hvy (obj dist); for partial Gaps at ends of closed 2D/3DPoly only
  (command
    "_.break" obj
    (vlax-curve-getPointAtDist obj dist)
    (vlax-curve-getEndPoint obj)
  ); end command
); end defun - BU-brkEnd-hvy
;; originally used (BU-brk (entlast) edash[2] (BU-entlen (entlast))) in all wrap-Gap
;; conditions in Center/Phantom families, but that break was not happening;
;; (BU-entlen (entlast)) seems to return something invalid.  Above works.

(defun BU-reset ()
  (setvar 'osmode osm)
  (setvar 'blipmode blipm)
  (setvar 'clayer clay)
  (command "_.undo" "_end")
  (setvar 'cmdecho cmde)
  (princ)
); end defun - BU-reset

;; ---------------------------------------------- BORDER family ----------------------------------------------

(defun C:BU-BORDER (/ BU-lt dash gap)
  (setq
    BU-lt "BORDER"
    dash (lts 0.5)
    gap (lts 0.25)
  ); setq
  (BU-DGDGPG)
); defun

(defun C:BU-BORDER2 (/ BU-lt dash gap)
  (setq
    BU-lt "BORDER2"
    dash (lts 0.25)
    gap (lts 0.125)
  ); setq
  (BU-DGDGPG)
); defun

(defun C:BU-BORDERX2 (/ BU-lt dash gap)
  (setq
    BU-lt "BORDERX2"
    dash (lts 1.0)
    gap (lts 0.5)
  ); setq
  (BU-DGDGPG)
); defun

(defun BU-DGDGPG ; for linetypes with Dash, Gap, Dash, Gap, Point, Gap [Border family]
  (/ *error* cycle cmde osm blipm BU-sel brkent unlk etype closed entlen
    elay cycles extra edash egap seg1len ecycle cyc1start wrap brktemp)
  (setq cycle (+ dash gap dash gap gap))
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (setvar 'clayer elay)
        (if closed
          (cond ; then - closed object
            ((= etype "Polyline"); LWPoly 1st cycle starts a long dash past param 1
              (BU-brk brkent (+ seg1len edash) (+ seg1len edash egap))
                ;; 1st break [1st gap] leaves in one piece with same entity name;
              (BU-pt brkent (+ edash egap))
              (BU-brk brkent edash (+ edash egap egap)); 2nd/3rd gaps
                ;; 2nd break leaves remainder as (entlast)
            ); end LWPolyline condition
            ((= etype "2dPolyline")
              (setq cyc1start (rem seg1len ecycle))
                ;; when (< seg1len ecycle), this will be distance *at* 2nd vertex/param 1
              (cond
                ((>= cyc1start (+ egap edash egap egap))
                  ;; T = 1st dash will wrap around or end at start/end vertex
                  (setq wrap nil)
                  (BU-brk brkent (- cyc1start egap edash egap egap) (- cyc1start egap egap edash))
                    ;; leaves 2DPoly downstream remainder as (entlast)
                  (setq brktemp (entlast))
                    ;; temporary break entity; next BU-brk can't use (entlast) because of added
                    ;; point, and not re-using brkent variable name because (ssdel) at end needs it
                  (BU-pt brktemp (+ edash egap))
                  (BU-brk brktemp edash (+ edash egap egap)); 2nd/3rd gaps
                ); end longer-dash wrap/end condition
                ((> (+ egap edash egap egap) cyc1start (+ edash egap egap))
                  ;; T = 1st gap will wrap around start/end vertex
                  (setq wrap "G1")
                  (BU-brk brkent 0 (- cyc1start egap egap edash)); portion of 1st gap
                  (setq brktemp (entlast))
                  (BU-pt brktemp (+ edash egap))
                  (BU-brk brktemp edash (+ edash egap egap)); 2nd/3rd gaps
                ); end 1st-gap condition
                ((>= (+ edash egap egap) cyc1start (+ egap egap))
                  ;; T = 2nd dash will wrap around or end at start/end vertex
                  (setq wrap "D2")
                  (BU-pt brkent (- cyc1start egap))
                  (BU-brk brkent (- cyc1start egap egap) cyc1start); 2nd/3rd gaps
                ); end 1st-shorter-dash condition
                ((> (+ egap egap) cyc1start egap)
                  ;; T = 2nd gap will wrap around start/end vertex
                  (setq wrap "G2")
                  (BU-pt brkent (- cyc1start egap))
                  (BU-brk brkent 0 cyc1start); portion of 2nd gap, 3rd gap
                ); end 2nd-gap condition
                ((= egap cyc1start)
                  ;; T = point at start/end vertex
                  (setq wrap "P")
                  (BU-pt brkent 0)
                  (BU-brk brkent 0 cyc1start); 3rd gap
                ); end point condition
                ((> egap cyc1start); T = 3rd gap will wrap around start/end vertex
                  (setq wrap "G3")
                  (BU-brk brkent 0 cyc1start)
                ); end 3rd-gap condition
              ); end cond - wrapping of start/end vertex
            ); end 2DPoly condition
            ((= etype "3dPolyline")
              (BU-brk brkent edash (+ edash egap)); 1st gap
                ;; 1st break leaves remainder as (entlast)
              (setq brktemp (entlast))
              (BU-pt brktemp (+ edash egap))
              (BU-brk brktemp edash (+ edash egap egap)); 2nd/3rd gaps
            ); end 3DPolyline condition
            ((wcmatch etype "Ellipse,Spline")
              (BU-brk brkent (/ edash 2) (+ (/ edash 2) egap))
                ;; 1st break leaves remainder with same entity name
              (BU-pt brkent (+ edash egap))
              (BU-brk brkent edash (+ edash egap egap)); 2nd/3rd gaps
                ;; 2nd break leaves remainder as (entlast)
            ); end Ellipse/Spline condition
            (T ; Circle has segment beginning at start point
              (BU-brk brkent edash (+ edash egap))
                ;; 1st break leaves remainder Arc with same entity name
              (BU-pt brkent (+ edash egap))
              (BU-brk brkent edash (+ edash egap egap)); 2nd/3rd gaps
                ;; 2nd break leaves remainder as (entlast)
            ); end none-of-the-above closed-object [Circle] condition
          ); end cond - then - closed-object entity type check
          (progn ; else - open-ended object
            (BU-brk brkent (+ extra dash) (+ extra dash gap))
              ;; leaves remainder of all types as (entlast)
            (setq brktemp (entlast))
            (BU-pt brktemp (+ dash gap))
            (BU-brk brktemp dash (+ dash gap gap)); 2nd/3rd gaps
          ); end progn - else - open-ended object
        ); end if [closed check and initial break cycle]
        (repeat (if (and closed (= etype "3dPolyline")) (1- cycles) cycles)
          ;; remaining after prior reduction(s), less special one for closed 3DPoly
          (BU-brk (entlast) (if closed edash dash) (if closed (+ edash egap) (+ dash gap)))
          (setq brktemp (entlast))
          (BU-pt brktemp (if closed (+ edash egap) (+ dash gap)))
          (BU-brk brktemp (if closed edash dash) (if closed (+ edash egap egap) (+ dash gap gap)))
        ); end repeat
        (cond ; special end breaking situations ['wrap' variables for 2DPoly, end of 3DPoly]
          ((and closed (= etype "2dPolyline") (= wrap "G1"))
            ;; finish 1st gap [end of 1st gap and 2nd/3rd gaps at beginning]
            (BU-brkEnd-hvy (entlast) edash)
          ); end G1 condition
          ((and closed (= etype "2dPolyline") (= wrap "D2"))
            ;; 1st gap of wrap-around cycle [2nd/3rd gaps at beginning]
            (BU-brk (entlast) edash (+ edash egap))
          ); end D2 condition
          ((and closed (= etype "2dPolyline") wrap (wcmatch wrap "G2,P"))
            ;; 1st gap & finish or all of 2nd of wrap-around cycle [end of 2nd gap & 3rd gap at beginning]
            (BU-brk (entlast) edash (+ edash egap)); 1st gap
            (BU-brkEnd-hvy (entlast) edash); finish 2nd gap
          ); end G2 or P condition
          ((and closed (or (and (= etype "2dPolyline") (= wrap "G3")) (= etype "3dPolyline")))
            ;; 1st/2nd gaps, point, & finish 3rd gap of wrap-around cycle [end of 3rd gap at beginning]
            ;; or special last cycle to avoid overshooting end of closed 3DPoly
            (BU-brk (entlast) edash (+ edash egap)); 1st gap
            (setq brktemp (entlast))
            (BU-pt brktemp (+ edash egap))
            (BU-brkEnd-hvy brktemp edash); portion of 3rd gap [all of it for 3DPoly] to end
          ); end G3/closed-3DPoly condition
        ); end cond - closing points/break(s)
      ); end progn - then  - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-DGDGPG [Border]

;; -------------------------------------------- CENTER family -------------------------------------------------

(defun C:BU-CENTER (/ BU-lt dash dash2 gap)
  (setq
    BU-lt "CENTER"
    dash (lts 1.25)
    dash2 (lts 0.25)
    gap (lts 0.25)
  ); setq
  (BU-DGD2G)
); defun

(defun C:BU-CENTER2 (/ BU-lt dash dash2 gap)
  (setq
    BU-lt "CENTER2"
    dash (lts 0.625)
      ;; NOTE: ACAD.lin has 0.75 [= neither half of CENTER's long dash, as in all
      ;; other ...2 linetypes, nor 5x the gap size, as in CENTER & CENTERX2].
      ;; This uses ratio consistent with others; to match look of ACAD's definition,
      ;; if desired, change 0.625 above to 0.75.
    dash2 (lts 0.125)
    gap (lts 0.125)
  ); setq
  (BU-DGD2G)
); defun

(defun C:BU-CENTERX2 (/ BU-lt dash dash2 gap)
  (setq
    BU-lt "CENTERX2"
    dash (lts 2.5)
    dash2 (lts 0.5)
    gap (lts 0.5)
  ); setq
  (BU-DGD2G)
); defun

(defun C:BU-CENTERLH (/ BU-lt dash dash2 gap)
;; [This is a custom linetype of ours, like Center but with the longer dash twice as long;
;; = Center-line with Long dash and Hyphen between (cf. CENTERLP in Dashdot family)]
  (setq
    BU-lt "CENTERLH"
    dash (lts 2.5)
    dash2 (lts 0.25)
    gap (lts 0.25)
  ); setq
  (BU-DGD2G)
); defun

(defun BU-DGD2G ; for linetypes with Dash, Gap, Dash2, Gap [Center family]
  (/ cycle *error* cmde osm clay blipm BU-sel brkent unlk etype closed entlen
    elay cycles extra edash edash2 egap seg1len ecycle cyc1start wrap)
  (setq cycle (+ dash gap dash2 gap))
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (if closed
          (cond ; then - closed object
            ((= etype "Polyline"); LWPoly 1st break cycle starts a long dash past param 1
              (BU-brk brkent (+ seg1len edash) (+ seg1len edash egap))
                ;; 1st break [1st gap] leaves in one piece with same entity name;
              (BU-brk brkent edash2 (+ edash2 egap)); complete cycle
                ;; 2nd break leaves remainder as (entlast)
            ); end LWPolyline condition
            ((= etype "2dPolyline")
              (setq cyc1start (rem seg1len ecycle))
                ;; when (< seg1len ecycle), this will be distance *at* 2nd vertex/param 1
              (cond
                ((>= cyc1start (+ egap edash2 egap))
                  ;; T = longer dash will wrap around or end at start/end vertex
                  (setq wrap nil)
                  (BU-brk brkent (- cyc1start egap edash2 egap) (- cyc1start egap edash2))
                    ;; leaves 2DPoly downstream remainder as (entlast)
                  (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
                ); end longer-dash wrap/end condition
                ((> (+ egap edash2 egap) cyc1start (+ egap edash2))
                  ;; T = 1st gap will wrap around start/end vertex
                  (setq wrap "G1")
                  (BU-brk brkent 0 (- cyc1start egap edash2))
                  (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
                ); end 1st-gap condition
                ((>= (+ egap edash2) cyc1start egap)
                  ;; T = shorter dash will wrap around or end at start/end vertex
                  (setq wrap "D2")
                  (BU-brk brkent (- cyc1start egap) cyc1start)
                ); end shorter-dash condition
                ((> egap cyc1start); T = 2nd gap will wrap around start/end vertex
                  (setq wrap "G2")
                  (BU-brk brkent 0 cyc1start); complete 1st cycle
                ); end 2nd-gap condition
              ); end cond - wrapping of start/end vertex
            ); end 2DPoly condition
            ((= etype "3dPolyline")
              (BU-brk brkent edash (+ edash egap))
                ;; 1st break leaves remainder as (entlast)
              (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
            ); end 3DPolyline condition
            ((wcmatch etype "Ellipse,Spline")
              (BU-brk brkent (/ edash 2) (+ (/ edash 2) egap))
                ;; 1st break leaves remainder with same entity name
              (BU-brk brkent edash2 (+ edash2 egap)); complete 1st cycle
                ;; 2nd break leaves remainder as (entlast)
            ); end Ellipse/Spline condition
            (T ; Circle has segment beginning at start point
              (BU-brk brkent edash (+ edash egap))
                ;; 1st break leaves remainder Arc with same entity name
              (BU-brk brkent edash2 (+ edash2 egap)); complete 1st cycle
                ;; 2nd break leaves remainder as (entlast)
            ); end none-of-the-above closed-object [Circle] condition
          ); end cond - then - closed-object entity type check
          (progn ; else - open-ended object
            (BU-brk brkent (+ extra dash) (+ extra dash gap))
              ;; leaves remainder of all types as (entlast)
            (BU-brk (entlast) dash2 (+ dash2 gap)); complete 1st cycle
          ); end progn - else - open-ended object
        ); end if [closed check and initial break cycle]
        (repeat (if (and closed (= etype "3dPolyline")) (1- cycles) cycles)
          ;; remaining after prior reduction(s), less special one for closed 3DPoly
          (BU-brk (entlast) (if closed edash dash) (if closed (+ edash egap) (+ dash gap)))
          (BU-brk (entlast) (if closed edash2 dash2) (if closed (+ edash2 egap) (+ dash2 gap)))
        ); end repeat
        (cond ; special end breaking situations ['wrap' variables for 2DPoly]
          ((and (= etype "2dPolyline") (= wrap "G1"))
            ;; finish 1st gap [end of 1st gap and 2nd gap at beginning]
            (BU-brkEnd-hvy (entlast) edash)
          ); end G1 condition
          ((and (= etype "2dPolyline") (= wrap "D2"))
            ;; 1st gap of wrap-around cycle [2nd gap at beginning]
            (BU-brk (entlast) edash (+ edash egap))
          ); end D2 condition
          ((and closed (or (and (= etype "2dPolyline") (= wrap "G2")) (= etype "3dPolyline")))
            ;; 1st gap & finish 2nd of wrap-around cycle [end of 2nd gap at beginning] for 2D,
            ;; or special last cycle to avoid overshooting end of closed 3DPoly
            (BU-brk (entlast) edash (+ edash egap)); 1st gap
            (BU-brkEnd-hvy (entlast) edash2); finish 2nd gap
          ); end G2/closed-3D condition
        ); end cond - closing break(s)
      ); end progn - then  - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-DGD2G [Center]

;; -------------------------------------------- DASHDOT family --------------------------------------------

(defun C:BU-DASHDOT (/ BU-lt dash gap)
  (setq
    BU-lt "DASHDOT"
    dash (lts 0.5)
    gap (lts 0.25)
  ); setq
  (BU-DGPG)
); defun

(defun C:BU-DASHDOT2 (/ BU-lt dash gap)
  (setq
    BU-lt "DASHDOT2"
    dash (lts 0.25)
    gap (lts 0.125)
  ); setq
  (BU-DGPG)
); defun

(defun C:BU-DASHDOTX2 (/ BU-lt dash gap)
  (setq
    BU-lt "DASHDOTX2"
    dash (lts 1.0)
    gap (lts 0.5)
  ); setq
  (BU-DGPG)
); defun

(defun C:BU-CENTERLP (/ BU-lt dash gap)
;; [This is a custom linetype of ours, like Dashdot but with a much longer dash; =
;; Center-line with Long dash and Point between (cf. CENTERLH in Center family)]
  (setq
    BU-lt "CENTERLP"
    dash (lts 2.5)
    gap (lts 0.2)
  ); setq
  (BU-DGPG)
); defun

(defun BU-DGPG ; for linetypes with Dash, Gap, Point, Gap [Dashdot family]
  (/ *error* cycle cmde osm blipm BU-sel brkent unlk etype closed entlen
    elay cycles extra edash egap seg1len ecycle cyc1start wrap brktemp)
  (setq cycle (+ dash gap gap))
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (setvar 'clayer elay)
        (if closed
          (cond ; then - closed object
            ((= etype "Polyline"); LWPoly 1st cycle starts a dash past param 1
              ;; point first, then break both gaps; do twice to get remainder to be entlast
              (BU-pt brkent (+ seg1len edash egap))
              (BU-brk brkent (+ seg1len edash) (+ seg1len edash egap egap)); both gaps around point
                ;; 1st break [1st gap] leaves in one piece with same entity name;
              (BU-pt brkent (+ edash egap))
              (BU-brk brkent edash (+ edash egap egap)); both gaps
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles))
            ); end LWPolyline condition
            ((= etype "2dPolyline")
              (setq cyc1start (rem seg1len ecycle))
                ;; when (< seg1len ecycle), this will be distance *at* 2nd vertex/param 1
              (cond
                ((>= cyc1start (+ egap egap))
                  ;; T = dash will wrap around or end at start/end vertex
                  (setq wrap nil)
                  (BU-pt brkent (- cyc1start egap))
                  (BU-brk brkent (- cyc1start egap egap) cyc1start); both gaps
                    ;; leaves 2DPoly downstream remainder as (entlast)
                ); end dash wrap/end condition
                ((> (+ egap egap) cyc1start egap)
                  ;; T = 1st gap will wrap around start/end vertex
                  (setq wrap "G1")
                  (BU-pt brkent (- cyc1start egap))
                  (BU-brk brkent 0 cyc1start); portion of 1st gap, & 2nd gap
                ); end 1st-gap condition
                ((= egap cyc1start)
                  ;; T = point at start/end vertex
                  (setq wrap "P")
                  (BU-pt brkent 0)
                  (BU-brk brkent 0 cyc1start); 2nd gap
                ); end point condition
                ((> egap cyc1start); T = 2nd gap will wrap around start/end vertex
                  (setq wrap "G2")
                  (BU-brk brkent 0 cyc1start)
                ); end 2nd-gap condition
              ); end cond - wrapping of start/end vertex
            ); end 2DPoly condition
            ((= etype "3dPolyline")
              (BU-pt brkent (+ edash egap))
              (BU-brk brkent edash (+ edash egap egap)); both gaps
                ;; 1st break leaves remainder as (entlast)
              (setq cycles (1- cycles)); for special end situation
            ); end 3DPolyline condition
            ((wcmatch etype "Ellipse,Spline"); dash straddles start/end point
              (BU-pt brkent (+ (/ edash 2) egap))
              (BU-brk brkent (/ edash 2) (+ (/ edash 2) egap egap))
                ;; 1st break leaves remainder with same entity name
              (BU-pt brkent (+ edash egap));;;; if long enough?
              (BU-brk brkent edash (+ edash egap egap)); both gaps
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles))
            ); end Ellipse/Spline condition
            (T ; Circle has segment beginning at start point
              (repeat 2
                (BU-pt brkent (+ edash egap))
                (BU-brk brkent edash (+ edash egap egap)); both gaps
                  ;; 1st break leaves remainder Arc with same entity name
                  ;; 2nd break leaves remainder as (entlast)
              ); end repeat
              (setq cycles (1- cycles))
            ); end none-of-the-above closed-object [Circle] condition
          ); end cond - then - closed-object entity type check
          (progn ; else - open-ended object
            (BU-pt brkent (+ extra dash gap))
            (BU-brk brkent (+ extra dash) (+ extra dash gap gap)); both gaps
              ;; leaves remainder of all types as (entlast)
          ); end progn - else - open-ended object
        ); end if [closed check and initial break cycle(s)]
        (repeat cycles ; remaining after prior reduction(s)
          ;; already did 2 for closed LWPoly/Ell/Spl/Circle; not for open things or 2D/3DPoly
          (setq brktemp (entlast))
            ;; temporary break entity; next BU-brk can't use (entlast) because of added
            ;; point, and not re-using brkent variable name because (ssdel) at end needs it
          (BU-pt brktemp (if closed (+ edash egap) (+ dash gap)))
          (BU-brk brktemp (if closed edash dash) (if closed (+ edash egap egap) (+ dash gap gap)))
        ); end repeat
        (cond ; special end breaking situations ['wrap' variables for 2DPoly, end of 3DPoly]
          ((and closed (= etype "2dPolyline") wrap (wcmatch wrap "G1,P"))
            ;; finish or all of 1st gap [possible end of 1st gap, point and 2nd gap at beginning]
            (BU-brkEnd-hvy (entlast) edash)
          ); end G1/P condition
          ((and closed (or (and (= etype "2dPolyline") (= wrap "G2")) (= etype "3dPolyline")))
            ;; 1st gap, point, & finish 2nd gap of wrap-around cycle [end of 2nrd gap at beginning]
            ;; or special last cycle to avoid overshooting end of closed 3DPoly
            (setq brktemp (entlast))
            (BU-pt brktemp (+ edash egap))
            (BU-brkEnd-hvy brktemp edash); 1st & portion of 2nd gap [all of it for 3DPoly] to end
          ); end G2/closed-3DPoly condition
        ); end cond - closing points/break(s)
      ); end progn - then  - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-DGPG [Dashdot]

;; -------------------------------- DASHED & HIDDEN families --------------------------------

(defun C:BU-DASHED (/ BU-lt dash gap)
  (setq
    BU-lt "DASHED"
    dash (lts 0.5)
    gap (lts 0.25)
  ); setq
  (BU-DG)
); defun

(defun C:BU-DASHED2 (/ BU-lt dash gap)
  (setq
    BU-lt "DASHED2"
    dash (lts 0.25)
    gap (lts 0.125)
  ); setq
  (BU-DG)
); defun

(defun C:BU-DASHEDX2 (/ BU-lt dash gap)
  (setq
    BU-lt "DASHEDX2"
    dash (lts 1.0)
    gap (lts 0.5)
  ); setq
  (BU-DG)
); defun

(defun C:BU-HIDDEN (/ BU-lt dash gap)
  (setq
    BU-lt "HIDDEN"
    dash (lts 0.25)
    gap (lts 0.125)
  ); setq
  (BU-DG)
); defun

(defun C:BU-HIDDEN2 (/ BU-lt dash gap)
  (setq
    BU-lt "HIDDEN2"
    dash (lts 0.125)
    gap (lts 0.0625)
  ); setq
  (BU-DG)
); defun

(defun C:BU-HIDDENX2 (/ BU-lt dash gap)
  (setq
    BU-lt "HIDDENX2"
    dash (lts 0.5)
    gap (lts 0.25)
  ); setq
  (BU-DG)
); defun

(defun BU-DG ; for linetypes with 1 Dash and 1 Gap [Dashed/Hidden families]
  (/ *error* cycle cmde osm clay blipm BU-sel brkent unlk etype closed
    entlen elay cycles extra ecycle edash egap seg1len cyc1start gwrap)
  (setq cycle (+ dash gap))
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (if closed
          (cond ; then - closed object
            ((wcmatch etype "Polyline,2dPolyline")
              (setq
                cyc1start (rem seg1len ecycle)
                  ;; when (< seg1len ecycle), this will be *at* 2nd vertex/param 1
                gwrap (> egap cyc1start); T = gap will wrap around start/end vertex
              ); end setq
              (BU-brk brkent cyc1start
                ;; 1st break leaves remainder LWPoly with same entity name, 2DPoly as (entlast)
                (if gwrap ; can't break from *before* start point
                  0 ; just back to beginning
                  (- cyc1start egap)
                ); end if
              ); end BU-brk
              (if (= etype "Polyline"); = LWPolyline
                (progn ; then
                  (BU-brk brkent edash ecycle)
                    ;; 2nd break leaves remainder LWpoly as (entlast)
                  (setq cycles (1- cycles)); reduce again for 2nd break, LWPoly only
                ); end progn - then - LWPoly
              ); end if - LWPoly [no else if 2DPoly]
            ); end LW/2DPoly condition
            ((= etype "3dPolyline")
              (BU-brk brkent edash ecycle)
                ;; 1st break leaves remainder as (entlast)
              (setq cycles (1- cycles)); reduce for special end condition
            ); end 3DPolyline condition
            ((wcmatch etype "Ellipse,Spline")
              (BU-brk brkent (/ edash 2) (- ecycle (/ edash 2)))
                ;; 1st break leaves remainder with same entity name
              (BU-brk brkent edash ecycle)
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles)); reduce again for 2nd break
            ); end Ellipse/Spline condition
            (T ; Circle has segment beginning at start point
              (BU-brk brkent edash ecycle)
                ;; 1st break leaves remainder Arc with same entity name
              (BU-brk brkent edash ecycle)
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles)); reduce again for 2nd break
            ); end none-of-the-above closed-object [Circle] condition
          ); end cond - then - closed-object entity type check
          (BU-brk brkent (+ extra dash) (+ extra cycle)) ; else - open-ended object
            ;; leaves remainder as (entlast)
        ); end if [closed check and initial break(s)]
        (repeat cycles ; remaining after reductions above
          (BU-brk (entlast) (if closed edash dash) (if closed ecycle cycle))
        ); end repeat
        (if ; special end condition
          (and closed (or gwrap (= etype "3dPolyline")))
          (BU-brk (entlast) edash (BU-entlen (entlast)))
            ;; take out last part of closed LW/2D/3DPoly to original start/end vertex
        ); end if - special end condition
      ); end progn - then  - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-DG [Dashed/Hidden]

;; -------------------------------------------- DIVIDE family --------------------------------------------

(defun C:BU-DIVIDE (/ BU-lt dash gap)
  (setq
    BU-lt "DIVIDE"
    dash (lts 0.5)
    gap (lts 0.25)
  ); setq
  (BU-DGPGPG)
); defun

(defun C:BU-DIVIDE2 (/ BU-lt dash gap)
  (setq
    BU-lt "DIVIDE2"
    dash (lts 0.25)
    gap (lts 0.125)
  ); setq
  (BU-DGPGPG)
); defun

(defun C:BU-DIVIDEX2 (/ BU-lt dash gap)
  (setq
    BU-lt "DIVIDEX2"
    dash (lts 1.0)
    gap (lts 0.5)
  ); setq
  (BU-DGPGPG)
); defun

(defun C:BU-PROPERTY (/ BU-lt dash gap)
;; [This is a custom linetype of ours, like Divide but with a much longer dash]
  (setq
    BU-lt "PROPERTY"
    dash (lts 6)
    gap (lts 0.25)
  ); setq
  (BU-DGPGPG)
); defun

(defun BU-DGPGPG ; for linetypes with Dash, Gap, Point, Gap, Point, Gap [Divide family]
  (/ *error* cycle cmde osm blipm BU-sel brkent unlk etype closed entlen
    elay cycles extra edash egap seg1len ecycle cyc1start wrap brktemp)
  (setq cycle (+ dash gap gap gap))
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (setvar 'clayer elay)
        (if closed
          (cond ; then - closed object
            ((= etype "Polyline"); LWPoly 1st cycle starts a long dash past param 1
              (BU-pt brkent (+ seg1len edash egap)); 1st point
              (BU-pt brkent (+ seg1len edash egap egap)); 2nd point
              (BU-brk brkent (+ seg1len edash) (+ seg1len edash egap egap egap)); all gaps
                ;; 1st break leaves in one piece with same entity name;
              (BU-pt brkent (+ edash egap)); 1st point;;;; if long enough?
              (BU-pt brkent (+ edash egap egap)); 2nd point
              (BU-brk brkent edash (+ edash egap egap egap)); all gaps
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles))
            ); end LWPolyline condition
            ((= etype "2dPolyline")
              (setq cyc1start (rem seg1len ecycle))
                ;; when (< seg1len ecycle), this will be distance *at* 2nd vertex/param 1
              (cond
                ((>= cyc1start (+ egap egap egap))
                  ;; T = dash will wrap around or end at start/end vertex
                  (setq wrap nil)
                  (BU-pt brkent (- cyc1start egap egap egap)); 1st point
                  (BU-pt brkent (- cyc1start egap egap)); 2nd point
                  (BU-brk brkent (- cyc1start egap egap egap) cyc1start); all gaps
                    ;; leaves 2DPoly downstream remainder as (entlast)
                ); end dash wrap/end condition
                ((> (+ egap egap egap) cyc1start (+ egap egap))
                  ;; T = 1st gap will wrap around start/end vertex
                  (setq wrap "G1")
                  (BU-pt brkent (- cyc1start egap egap)); 1st point
                  (BU-pt brkent (- cyc1start egap)); 2nd point
                  (BU-brk brkent 0 cyc1start); end of 1st gap, & 2nd/3rd gaps
                ); end 1st-gap condition
                ((= (+ egap egap) cyc1start)
                  ;; T = 1st point at start/end vertex
                  (setq wrap "P1")
                  (BU-pt brkent 0); 1st point
                  (BU-pt brkent (- cyc1start egap)); 2nd point
                  (BU-brk brkent 0 cyc1start); 2nd/3rd gaps
                ); end 1st-point condition
                ((> (+ egap egap) cyc1start egap)
                  ;; T = 2nd gap will wrap around start/end vertex
                  (setq wrap "G2")
                  (BU-pt brkent (- cyc1start egap)); 2nd point
                  (BU-brk brkent 0 cyc1start); end of 2nd gap, & 3rd gap
                ); end 2nd-gap condition
                ((= egap cyc1start)
                  ;; T = 2nd point at start/end vertex
                  (setq wrap "P2")
                  (BU-pt brkent 0); 2nd point
                  (BU-brk brkent 0 cyc1start); 3rd gap
                ); end 2nd-point condition
                ((> egap cyc1start); T = 3rd gap will wrap around start/end vertex
                  (setq wrap "G3")
                  (BU-brk brkent 0 cyc1start); end of 3rd gap
                ); end 3rd-gap condition
              ); end cond - wrapping of start/end vertex
            ); end 2DPoly condition
            ((= etype "3dPolyline")
              (BU-pt brkent (+ edash egap)); 1st point
              (BU-pt brkent (+ edash egap egap)); 2nd point
              (BU-brk brkent edash (+ edash egap egap egap)); all gaps
                ;; leaves remainder as (entlast)
              (setq cycles (1- cycles)); for special end condition
            ); end 3DPolyline condition
            ((wcmatch etype "Ellipse,Spline")
              (BU-pt brkent (+ (/ edash 2) egap)); 1st point
              (BU-pt brkent (+ (/ edash 2) egap egap)); 2nd point
              (BU-brk brkent (/ edash 2) (+ (/ edash 2) egap egap egap)); all gaps
                ;; leaves remainder with same entity name
              (BU-pt brkent (+ edash egap)); 1st point
              (BU-pt brkent (+ edash egap egap)); 2nd point
              (BU-brk brkent edash (+ edash egap egap egap)); all gaps
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles)); did 2 cycles to get to (entlast)
            ); end Ellipse/Spline condition
            (T ; Circle has segment beginning at start point
              (BU-pt brkent (+ edash egap)); 1st point
              (BU-pt brkent (+ edash egap egap)); 2nd point
              (BU-brk brkent edash (+ edash egap egap egap)); all gaps
                ;; 1st break leaves remainder Arc with same entity name
              (BU-pt brkent (+ edash egap)); 1st point
              (BU-pt brkent (+ edash egap egap)); 2nd point
              (BU-brk brkent edash (+ edash egap egap egap)); all gaps
                ;; 2nd break leaves remainder as (entlast)
              (setq cycles (1- cycles)); did 2 cycles to get to (entlast)
            ); end none-of-the-above closed-object [Circle] condition
          ); end cond - then - closed-object entity type check
          (progn ; else - open-ended object
            (BU-pt brkent (+ extra dash gap)); 1st point
            (BU-pt brkent (+ extra dash gap gap)); 2nd point
            (BU-brk brkent (+ extra dash) (+ extra dash gap gap gap)); all gaps
              ;; leaves remainder of all types as (entlast)
          ); end progn - else - open-ended object
        ); end if [closed check and initial break cycle]
        (repeat cycles
          ;; remaining after prior reduction(s)
          (setq brktemp (entlast))
            ;; temporary break entity; next BU-brk can't use (entlast) because of added
            ;; points, and not re-using brkent variable name because (ssdel) at end needs it
          (BU-pt brktemp (if closed (+ edash egap) (+ dash gap))); 1st point
          (BU-pt brktemp (if closed (+ edash egap egap) (+ dash gap gap))); 2nd point
          (BU-brk brktemp; all gaps
            (if closed edash dash)
            (if closed (+ edash egap egap egap) (+ dash gap gap gap))
          ); end BU-brk
        ); end repeat
        (cond ; special end breaking situations ['wrap' variables for 2DPoly, end of 3DPoly]
          ((and closed (= etype "2dPolyline") wrap (wcmatch wrap "G1,P1"))
            ;; finish or all of 1st gap [possible end of 1st gap, points and 2nd/3rd gaps at beginning]
            (BU-brkEnd-hvy (entlast) edash)
          ); end G1/P1 condition
          ((and closed (= etype "2dPolyline") wrap (wcmatch wrap "G2,P2"))
            ;; 1st gap, 1st point, finish or all of 2nd gap [possible end of 2nd gap, 2nd point, 3rd gap at beginning]
            (setq brktemp (entlast))
            (BU-pt brktemp (+ edash egap)); 1st point
            (BU-brkEnd-hvy brktemp edash); gaps
          ); end G2/P2 condition
          ((and closed (or (and (= etype "2dPolyline") (= wrap "G3")) (= etype "3dPolyline")))
            ;; 1st/2nd gaps, points, & finish 3rd gap of wrap-around cycle [end of 3rd gap at beginning]
            ;; or special last cycle to avoid overshooting end of closed 3DPoly
            (setq brktemp (entlast))
            (BU-pt brktemp (+ edash gap)); 1st point
            (BU-pt brktemp (+ edash gap gap)); 2nd point
            (BU-brkEnd-hvy brktemp edash); 1st/2nd/part of 3rd gap [all of it for 3DPoly] to end
          ); end G3/closed-3DPoly condition
        ); end cond - closing points/break(s)
      ); end progn - then  - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-DGPGPG [Divide]

;; ---------------------------------------------- DOT family ----------------------------------------------

(defun C:BU-DOT (/ BU-lt gap)
  (setq
    BU-lt "DOT"
    gap (lts 0.25)
  ); setq
  (BU-PG)
); defun

(defun C:BU-DOT2 (/ BU-lt gap)
  (setq
    BU-lt "DOT2"
    gap (lts 0.125)
  ); setq
  (BU-PG)
); defun

(defun C:BU-DOTX2 (/ BU-lt gap)
  (setq
    BU-lt "DOTX2"
    gap (lts 0.5)
  ); setq
  (BU-PG)
); defun

(defun BU-PG ; for linetypes with 1 Point and 1 Gap [Dot family]
  (/ *error* cycle cmde osm clay blipm BU-sel brkent unlk etype closed entlen elay cycles inc)
  (setq cycle gap)
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (setvar 'clayer elay)
        (if (not closed)
          (progn
            (setq cycles (fix (+ (/ entlen cycle) 0.5)))
            (command ; add Points at ends of open objects
              "_.point" (vlax-curve-getStartPoint brkent)
              "_.point" (vlax-curve-getEndPoint brkent)
            ); end command
          ); end progn
        ); end if - open-ended object
        (if (and (wcmatch etype "Polyline,2dPolyline") closed)
          (progn ; then - closed 2D/LWPoly only
            (setq inc 0)
            (repeat cycles
              (command
                "_.point"
                (vlax-curve-getPointAtDist
                  brkent
                  (+ (rem seg1len egap) (* inc egap))
                    ;; to put Point at vertex 2/param 1
                ); end getPoint
              ); end command
              (setq inc (1+ inc))
            ); end repeat
          ); end progn - then - closed 2D/LWPoly
          (command "_.divide" brkent cycles); else - all others
        ); end if - closed 2D/LWPoly
        (entdel brkent)
      ); end progn - then - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-PG [Dot]

;; ----------------------- HIDDEN family [see BU-DG under DASHED] -----------------------

;; ------------------------------------------ PHANTOM family ------------------------------------------

(defun C:BU-PHANTOM (/ BU-lt dash dash2 gap)
  (setq
    BU-lt "PHANTOM"
    dash (lts 1.25)
    dash2 (lts 0.25)
    gap (lts 0.25)
  ); setq
  (BU-DGD2GD2G)
); defun

(defun C:BU-PHANTOM2 (/ BU-lt dash dash2 gap)
  (setq
    BU-lt "PHANTOM2"
    dash (lts 0.625)
    dash2 (lts 0.125)
    gap (lts 0.125)
  ); setq
  (BU-DGD2GD2G)
); defun

(defun C:BU-PHANTOMX2 (/ BU-lt dash dash2 gap)
  (setq
    BU-lt "PHANTOMX2"
    dash (lts 2.5)
    dash2 (lts 0.5)
    gap (lts 0.5)
  ); setq
  (BU-DGD2GD2G)
); defun

(defun BU-DGD2GD2G ; for linetypes with Dash, Gap, Dash2, Gap, Dash2, Gap [Phantom family]
  (/ *error* cycle cmde osm clay blipm BU-sel brkent unlk etype closed entlen
    elay cycles extra edash edash2 egap seg1len ecycle cyc1start wrap)
  (setq cycle (+ dash gap dash2 gap dash2 gap))
  (BU-common)
  (repeat (sslength BU-sel)
    (BU-entinfo)
    (if unlk ; set in BU-entinfo if object is on unlocked Layer
      (progn ; then - unlocked
        (if closed
          (cond ; then - closed object
            ((= etype "Polyline"); LWPoly 1st cycle starts a long dash past param 1
              (BU-brk brkent (+ seg1len edash) (+ seg1len edash egap))
                ;; 1st break [1st gap] leaves in one piece with same entity name;
              (BU-brk brkent edash2 (+ edash2 egap)); 2nd gap
                ;; 2nd break leaves remainder as (entlast)
             (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
            ); end LWPolyline condition
            ((= etype "2dPolyline")
              (setq cyc1start (rem seg1len ecycle))
                ;; when (< seg1len ecycle), this will be distance *at* 2nd vertex/param 1
              (cond
                ((>= cyc1start (+ egap edash2 egap edash2 egap))
                  ;; T = longer dash will wrap around or end at start/end vertex
                  (setq wrap nil)
                  (BU-brk brkent (- cyc1start egap edash2 egap edash2 egap) (- cyc1start egap edash2 egap edash2))
                    ;; leaves 2DPoly downstream remainder as (entlast)
                  (BU-brk (entlast) edash2 (+ edash2 egap)); 2nd gap
                  (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
                ); end longer-dash wrap/end condition
                ((> (+ egap edash2 egap edash2 egap) cyc1start (+ egap edash2 egap edash2))
                  ;; T = 1st gap will wrap around start/end vertex
                  (setq wrap "G1")
                  (BU-brk brkent 0 (- cyc1start egap edash2 egap edash2));portion of 1st gap
                  (BU-brk (entlast) edash2 (+ edash2 egap)); 2nd gap
                  (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
                ); end 1st-gap condition
                ((>= (+ egap edash2 egap edash2) cyc1start (+ egap edash2 egap))
                  ;; T = 1st shorter dash will wrap around or end at start/end vertex
                  (setq wrap "D2")
                  (BU-brk brkent (- cyc1start egap edash2 egap) (- cyc1start egap edash2)); 2nd gap
                  (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
                ); end 1st-shorter-dash condition
                ((> (+ egap edash2 egap) cyc1start (+ egap edash2))
                  ;; T = 2nd gap will wrap around start/end vertex
                  (setq wrap "G2")
                  (BU-brk brkent 0 (- cyc1start egap edash2)); portion of 2nd gap
                  (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
                ); end 2nd-gap condition
                ((>= (+ egap edash2) cyc1start egap)
                  ;; T = 2nd shorter dash will wrap around or end at start/end vertex
                  (setq wrap "D3")
                  (BU-brk brkent (- cyc1start egap) cyc1start); 3rd gap
                ); end 1st-shorter-dash condition
                ((> egap cyc1start); T = 3rd gap will wrap around start/end vertex
                  (setq wrap "G3")
                  (BU-brk brkent 0 cyc1start)
                ); end 3rd-gap condition
              ); end cond - wrapping of start/end vertex
            ); end 2DPoly condition
            ((= etype "3dPolyline")
              (BU-brk brkent edash (+ edash egap))
                ;; 1st break leaves remainder as (entlast)
              (BU-brk (entlast) edash2 (+ edash2 egap)); 2nd gap
              (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
            ); end 3DPolyline condition
            ((wcmatch etype "Ellipse,Spline")
              (BU-brk brkent (/ edash 2) (+ (/ edash 2) egap))
                ;; 1st break leaves remainder with same entity name
              (BU-brk brkent edash2 (+ edash2 egap))
                ;; 2nd break leaves remainder as (entlast)
              (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
            ); end Ellipse/Spline condition
            (T ; Circle has segment beginning at start point
              (BU-brk brkent edash (+ edash egap))
                ;; 1st break leaves remainder Arc with same entity name
              (BU-brk brkent edash2 (+ edash2 egap))
                ;; 2nd break leaves remainder as (entlast)
              (BU-brk (entlast) edash2 (+ edash2 egap)); complete 1st cycle
            ); end none-of-the-above closed-object [Circle] condition
          ); end cond - then - closed-object entity type check
          (progn ; else - open-ended object
            (BU-brk brkent (+ extra dash) (+ extra dash gap))
              ;; leaves remainder of all types as (entlast)
            (BU-brk (entlast) dash2 (+ dash2 gap)); 2nd gap
            (BU-brk (entlast) dash2 (+ dash2 gap)); complete cycle
          ); end progn - else - open-ended object
        ); end if [closed check and initial break cycle]
        (repeat (if (and closed (= etype "3dPolyline")) (1- cycles) cycles)
          ;; remaining after prior reduction(s), less special one for closed 3DPoly
          (BU-brk (entlast) (if closed edash dash) (if closed (+ edash egap) (+ dash gap)))
          (BU-brk (entlast) (if closed edash2 dash2) (if closed (+ edash2 egap) (+ dash2 gap)))
          (BU-brk (entlast) (if closed edash2 dash2) (if closed (+ edash2 egap) (+ dash2 gap)))
        ); end repeat
        (cond ; special end breaking situations ['wrap' variables for 2DPoly]
          ((and (= etype "2dPolyline") (= wrap "G1"))
            ;; finish 1st gap [end of 1st gap and 2nd/3rd gaps at beginning]
            (BU-brkEnd-hvy (entlast) edash)
          ); end G1 condition
          ((and (= etype "2dPolyline") (= wrap "D2"))
            ;; 1st gap of wrap-around cycle [2nd/3rd gaps at beginning]
            (BU-brk (entlast) edash (+ edash egap))
          ); end D2 condition
          ((and (= etype "2dPolyline") (= wrap "G2"))
            ;; 1st gap & finish 2nd of wrap-around cycle [end of 2nd gap & 3rd gap at beginning]
            (BU-brk (entlast) edash (+ edash egap)); 1st gap
            (BU-brkEnd-hvy (entlast) edash2); finish 2nd gap
          ); end G2 condition
          ((and (= etype "2dPolyline") (= wrap "D3"))
            ;; 1st/2nd gaps of wrap-around cycle [3rd gap at beginning]
            (BU-brk (entlast) edash (+ edash egap)); 1st gap
            (BU-brk (entlast) edash2 (+ edash2 egap)); 2nd gap
          ); end D3 condition
          ((and closed (or (and (= etype "2dPolyline") (= wrap "G3")) (= etype "3dPolyline")))
            ;; 1st/2nd gaps & finish 3rd of wrap-around cycle [end of 3rd gap at beginning]
            ;; or special last cycle to avoid overshooting end of closed 3DPoly
            (BU-brk (entlast) edash (+ edash egap)); 1st gap
            (BU-brk (entlast) edash2 (+ edash2 egap)); 2nd gap
            (BU-brkEnd-hvy (entlast) edash2); portion of 3rd gap [all of it for 3DPoly] to end
          ); end G3/closed-3DPoly condition
        ); end cond - closing break(s)
      ); end progn - then  - unlocked
    ); end if - unlocked Layer [no else argument for locked Layer - do nothing]
    (ssdel brkent BU-sel)
  ); end repeat
  (BU-reset)
); end defun - BU-DGD2GD2G [Phantom]

; ------------------------------------------------------------------------

(prompt "\nType BU- followed by linetype name to Break Up into short entities and gaps to emulate that linetype.")
(princ)
