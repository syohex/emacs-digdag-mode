;;; digdag-mode.el --- major mode of Treasure Data digdag file -*- lexical-binding: t; -*-

;; Copyright (C) 2016 by Syohei YOSHIDA

;; Author: Syohei YOSHIDA <syohex@gmail.com>
;; URL: https://github.com/syohex/
;; Version: 0.01
;; Package-Requires: ((emacs "24") (yaml-mode "0.0.12"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A major-mode for editing Treasure Data digdag file.

;;; Code:

(require 'yaml-mode)

(defgroup digdag nil
  "Treasure Data digdag major mode"
  :group 'langauges)

(defface digdag-task
  '((t (:foreground "green")))
  "Face of digdag operators")

(defface digdag-operator
  '((t (:foreground "red")))
  "Face of digdag operators")

(defvar digdag-mode--date-regex
  (concat "^\\("
          (regexp-opt '("timezone" "session_uuid" "session_time" "session_date"
                        "session_date_compact" "session_local_time" "session_tz_offset"
                        "session_unixtime") 'symbols)
          "\\)\\s-*:"))

(defvar digdag-mode--control-regex
  (concat "^\\(schedule\\)\\s-*:"))

(defvar digdag-mode--builtin-regex
  (concat "\\("
          (regexp-opt '("_export" "_parallel" "_background" "_error" "!include") 'symbols)
          "\\)\\s-*:"))

(defvar digdag-mode--condition-regex
  (concat "\\("
          (regexp-opt '("if" "fail" "td" "td_run") 'symbols)
          ">\\)\\s-*:"))

(defvar digdag-mode--directive-regex
  "\\(\\sw+>\\)\\s-*:")

(defvar digdag-mode--font-lock-keywords
  `((,digdag-mode--date-regex . (1 font-lock-constant-face))
    (,digdag-mode--control-regex . (1 font-lock-constant-face))
    ("\\_<\\(\\+\\sw+\\)\\_>" . (1 'digdag-task))
    (,digdag-mode--builtin-regex . (1 font-lock-builtin-face))
    (,digdag-mode--condition-regex . (1 font-lock-keyword-face))
    (,digdag-mode--directive-regex . (1 'digdag-operator))
    ,@yaml-font-lock-keywords))

;;;###autoload
(define-derived-mode digdag-mode yaml-mode "Digdag"
  "Major mode for editing Treasure Data digdag file"
  (setq font-lock-defaults '(digdag-mode--font-lock-keywords)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dig\\'" . digdag-mode))

(provide 'digdag-mode)

;;; digdag-mode.el ends here
