;;; funcs.el --- Coldpour Layer functions File
;;
;; Copyright (c) 2017 Michael Holm
;;
;; Author: Michael Holm <coldpour@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3



(defun coldpour/current-date ()
  "return todays datestring"
  (calendar-date-string (calendar-current-date) t))

(defun coldpour/today-heading ()
  "return today's date as a markdown heading1"
  (concat "# " (coldpour/current-date) " #"))

(defun coldpour/insert-today-heading ()
  "insert todays datestring"
  (open-line 2)
  (insert (coldpour/today-heading)))

(defun coldpour/insert-subheading ()
  (end-of-line)
  (newline 2)
  (insert (concat "##  ##"))
  (backward-char 3))

(defun coldpour/insert-headings ()
  (beginning-of-buffer)
  (if (equal
        (coldpour/today-heading)
        (buffer-substring (line-beginning-position) (line-end-position)))
      (coldpour/insert-subheading)
      ((lambda ()
         (coldpour/insert-today-heading)
         (coldpour/insert-subheading)))))

(defun coldpour/switch-to-notes ()
  "open configured notes file if non-nil"
  (interactive)
  (if coldpour/capture-file
      (find-file coldpour/capture-file)
      ((lambda ()
         (message "Capture file not specified. Define 'coldpour/capture-file' to enable note taking.")
         nil))))

(global-set-key "\C-xg" 'coldpour/switch-to-notes)

(defun coldpour/capture ()
  "open configured notes file,
   insert todays datestring as a heading if it's not already there,
   and insert a blank subheading for easy note taking"
  (interactive)
  (if (coldpour/switch-to-notes)
      (coldpour/insert-headings)))

;; TODO use spacemacs keys for this
;; and something less like the quit keys
(global-set-key "\C-xc" 'coldpour/capture)

;; TODO add to markdown mode/layer
(defun coldpour/markdown-bullet (beg end)
  "Create a bulleted list from each line in the region. If there is no region, just add a bullet to the current line."
  (interactive "r")
  (let ((indent (current-column)))
    (goto-char beg)
    (beginning-of-line)
    (while (and (not (looking-at "[ \t]*$"))
                (<= (point) end))
      (insert "* ")
      (setq end (+ end 2))
      (forward-line))))
