;;;
;;; $Id: //droopi/main/utils/update-headers.el#4 $
;;;
;;; Emacs macros to update Ada source files headers.
;;;
;;;

;;
;; update-header: update on header file
;;
;; the function header-template returns new header template,
;; XXXXX will be replaced by context-dependent information.
;;
;; secondary header information will be inserted  in YYYYY 
;; given context.

(defun update-header ()
  "Update headers according to header.txt."
  (interactive)
  (let (name spec)

    ; delette previous header box, if any.
    (goto-char (point-min))
    (next-line 1)
    (if (re-search-forward "^----------" nil t)
	(progn
	  (next-line 1)
	  (beginning-of-line)
	  (delete-region (point-min) (point))))

    ; compute 'name' and 'spec'
    (goto-char (point-min))
    (if (re-search-forward "package body \\(.+\\) is" nil t)
	(setq name (buffer-substring (match-beginning 1) (match-end 1)))
      (goto-char (point-min))
      (if (re-search-forward "package \\(.+\\) \\(is\\|renames\\)" nil t)
	  (setq name (buffer-substring (match-beginning 1) (match-end 1))
		spec t)
	(goto-char (point-min))
	(if (re-search-forward "^procedure \\([^ ;]+\\)" nil t)
	    (setq name (buffer-substring (match-beginning 1) (match-end 1))
		  spec (string-match "ads" (buffer-name)))
	  (goto-char (point-min))
	  (if (re-search-forward "^function \\([^ ;]+\\)" nil t)
	      (setq name (buffer-substring (match-beginning 1) (match-end 1))
		    spec (string-match "ads" (buffer-name)))))))

    ; insert header template
    (goto-char (point-min))
    (insert (header-template))

    ; update file name and type.
    (goto-char (point-min))
    (re-search-forward "^XXXXX" nil)
    (beginning-of-line)
    (let ((beg (point)))
      (next-line 1) (delete-region beg (point)))
    (insert (center-ada (upcase (expand-ada-name name))))
    (insert (center-ada ""))
    (insert (center-ada (if spec "S p e c" "B o d y")))

    ; add secondary header file if necessary.
    (goto-char (point-min))
    (re-search-forward "^YYYYY" nil)
    (beginning-of-line)
    (let ((beg (point)))
      (next-line 1) (delete-region beg (point)))
    (insert-secondary-header spec)

    ; add a new line after header.
    (re-search-forward "----------")
    (next-line 1)
    (let ((beg (point)))
      (end-of-line)
      (if (not (equal (buffer-substring beg (point)) ""))
	  (progn
	    (beginning-of-line)
	    (insert "\n"))))

    ; output revision id.
    (goto-char (point-min))
    (if (not (re-search-forward "^--  $Id:" nil t))
	(progn
	  (goto-char (point-min))
	  (re-search-forward "^[a-z]")
	  (beginning-of-line)
	  (insert (concat "--  $" "Id:$\n\n"))))))

;;
;; insert-secondary-header: add secondary header if necessary
;;

(defun insert-secondary-header(spec)
  ; add OMG notice for CORBA.* and PortableServer.* spec files
  (if (and (or (string-match "corba" (buffer-name))
	       (string-match "portableserver" (buffer-name)))
	   spec)
      (insert (header-omg))))

;;
;; expand-ada-name: expand a litteral
;;

(defun expand-ada-name (n)
  (if (or (<= (length n) 1) (> (length n) 35)) n
    (concat (substring n 0 1) " " (expand-ada-name (substring n 1)))))

;;
;; center-ada: center text
;;

(defun center-ada (l &optional omit-terminator)
  (let* ((tt 71)
	 (n (length l))
	 (s (/ (- tt n) 2)))
    (concat "-- " (spaces-ada s) l
	    (if omit-terminator ""
	      (concat (spaces-ada (- tt (+ s n))) "  --"))
	    "\n")))
;;
;; spaces-ada: put n white spaces.
;;

(defun spaces-ada (n)
  (if (<= n 0) ""
    (concat " " (spaces-ada (- n 1)))))

;;
;; update-headers: update headers in all files given on the command line.
;;

(defun update-headers ()
  "Update headers of files given on the command line"
  (interactive)
  (let ((l (directory-files "." nil "\\.ad[bs]\\(\\.in\\|\\)$" nil t)))
    (while l
      (let ((current (car l)))
	(message "Updating %s..." current)
	(find-file current)
	(if (not buffer-read-only)
	    (progn
	      (update-header)
	      (write-file current)
	      (message "Updating %s... done" current)))
	(setq l (cdr l))))))

;;
;; header-template: main PolyORB header
;;

(defun header-template ()
"------------------------------------------------------------------------------
--                                                                          --
--                           POLYORB COMPONENTS                             --
--                                                                          --
XXXXX
--                                                                          --
--         Copyright (C) 1999-2003 Free Software Foundation, Inc.           --
--                                                                          --
YYYYY
-- PolyORB is free software; you  can  redistribute  it and/or modify it    --
-- under terms of the  GNU General Public License as published by the  Free --
-- Software Foundation;  either version 2,  or (at your option)  any  later --
-- version. PolyORB is distributed  in the hope that it will be  useful,    --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License  for more details.  You should have received  a copy of the GNU  --
-- General Public License distributed with PolyORB; see file COPYING. If    --
-- not, write to the Free Software Foundation, 59 Temple Place - Suite 330, --
-- Boston, MA 02111-1307, USA.                                              --
--                                                                          --
-- As a special exception,  if other files  instantiate  generics from this --
-- unit, or you link  this unit with other files  to produce an executable, --
-- this  unit  does not  by itself cause  the resulting  executable  to  be --
-- covered  by the  GNU  General  Public  License.  This exception does not --
-- however invalidate  any other reasons why  the executable file  might be --
-- covered by the  GNU Public License.                                      --
--                                                                          --
--                PolyORB is maintained by ACT Europe.                      --
--                    (email: sales@act-europe.fr)                          --
--                                                                          --
------------------------------------------------------------------------------")

;;
;; header-omg: secondary header for CORBA specs.
;;

(defun header-omg ()
"-- This specification is derived from the CORBA Specification, and adapted  --
-- for use with PolyORB. The copyright notice above, and the license        --
-- provisions that follow apply solely to the contents neither explicitely  --
-- nor implicitely specified by the CORBA Specification defined by the OMG. --
--                                                                          --
")