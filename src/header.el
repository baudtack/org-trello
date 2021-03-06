;;; org-trello.el --- Org minor mode to synchronize with trello

;; Copyright (C) 2013 Antoine R. Dumont <eniotna.t AT gmail.com>

;; Author: Antoine R. Dumont <eniotna.t AT gmail.com>
;; Maintainer: Antoine R. Dumont <eniotna.t AT gmail.com>
;; Version: 0.3.3
;; Package-Requires: ((emacs "24.3") (dash "2.5.0") (request "0.2.0") (cl-lib "0.3.0") (json "1.2") (elnode "0.9.9.7.6") (esxml "0.3.0") (s "1.7.0") (kv "0.0.19"))
;; Keywords: org-mode trello sync org-trello
;; URL: https://github.com/ardumont/org-trello

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Minor mode for org-mode to sync org-mode and trello
;;
;; 1) Add the following to your emacs init file
;; (require 'org-trello)
;; (add-hook 'org-mode-hook 'org-trello-mode)
;;
;; 2) Once - Install the consumer-key and the read-write token for org-trello to be able to work in your name with your trello boards (C-c o i)
;; M-x org-trello/install-key-and-token
;;
;; 3) Once per org-mode file/board you want to connect to (C-c o I)
;; M-x org-trello/install-board-and-lists-ids
;;
;; 4) You can also create a board directly from a org-mode buffer (C-c o b)
;; M-x org-trello/create-board
;;
;; 5) Check your setup (C-c o d)
;; M-x org-trello/check-setup
;;
;; 6) Help (C-c o h)
;; M-x org-trello/help-describing-setup

;;; Code:


(require 'org)
(require 'json)
(require 'dash)
(require 'request)
(eval-when-compile (require 'cl-lib))
(require 'cl-lib)
(require 'parse-time)
(require 'elnode)
(require 'timer)
(require 's)
(require 'kv)
(require 'esxml)
(require 'align)

(when (version< emacs-version "24.3")
      (error (concat "Oops - your emacs isn't supported. org-trello only works on Emacs 24.3+ and you're running version: " emacs-version ". Please upgrade your Emacs and try again.")))

(defvar *ORGTRELLO-VERSION* "0.3.3"  "current org-trello version installed.")


