;; internal.el -- setup support for PC keyboards and screens, internal terminal

;; Copyright (C) 1993, 1994 Free Software Foundation, Inc.

;; Author: Morten Welinder <terra@diku.dk>
;; Version: 1,02

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;; ---------------------------------------------------------------------------
;; screen setup -- that's easy!
(standard-display-8bit 127 254)
;; ---------------------------------------------------------------------------
;; keyboard setup -- that's simple!
(set-input-mode nil nil 0)
(define-key function-key-map [backspace] "\177") ; Normal behavior for BS
(define-key function-key-map [delete] "\C-d")    ; ... and Delete
(define-key function-key-map [tab] [?\t])
(define-key function-key-map [linefeed] [?\n])
(define-key function-key-map [clear] [11])
(define-key function-key-map [return] [13])
(define-key function-key-map [escape] [?\e])
(define-key function-key-map [M-backspace] [?\M-\d])
(define-key function-key-map [M-delete] [?\M-\d])
(define-key function-key-map [M-tab] [?\M-\t])
(define-key function-key-map [M-linefeed] [?\M-\n])
(define-key function-key-map [M-clear] [?\M-\013])
(define-key function-key-map [M-return] [?\M-\015])
(define-key function-key-map [M-escape] [?\M-\e])

;; ---------------------------------------------------------------------------
;; We want to do this when Emacs is started because it depends on the
;; country code.
(let* ((i 128)
      (modify (function
	       (lambda (ch sy) 
		 (modify-syntax-entry ch sy text-mode-syntax-table)
		 (if (boundp 'tex-mode-syntax-table)
		     (modify-syntax-entry ch sy tex-mode-syntax-table))
		 (modify-syntax-entry ch sy (standard-syntax-table))
		 )))
      (table (standard-case-table))
      ;; The following are strings of letters, first lower then upper case.
      ;; This will look funny on terminals which display other code pages.
      (chars
       (cond
	((= dos-codepage 850)
	 "???????????????????????????????????????????????????Y???I????????")
	((= dos-codepage 865)
	 "???????A???A???E?E?E?I?I?I???O???O?U?U?Y???A?I?O?U??")
	;; default is 437
	(t "???????A???A???E?E?E?I?I?I???O???O?U?U?Y?A?I?O?U??"))))

  (while (< i 256)
    (funcall modify i "_")
    (setq i (1+ i)))

  (setq i 0)
  (while (< i (length chars))
    (let ((ch1 (aref chars i))
	  (ch2 (aref chars (1+ i))))
      (if (> ch2 127)
	  (set-case-syntax-pair ch2 ch1 table))
      (setq i (+ i 2))))
  (save-excursion
    (mapcar (lambda (b) (set-buffer b) (set-case-table table))
	    (buffer-list)))
  (set-standard-case-table table))
