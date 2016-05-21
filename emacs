;;
;; Package archive for Emacs
;;
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(setq package-enable-at-startup nil) ;; To avoid initializing twice
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)



;;
;; Load user customisations
;;
(use-package emacs-custom-settings
  :load-path "lisp/")



;;
;; Look and feel
;;

;; Better frame titles
(setq frame-title-format (concat  "%b - emacs@" system-name))

;; More screen space
(tool-bar-mode 0)
(menu-bar-mode 0)

;; Position information
(setq line-number-mode t)
(setq column-number-mode t)
(global-linum-mode t)
(global-hl-line-mode t)

;; Indicate the percentage of the buffer above the top of the window
(setq size-indication-mode t)

;; Mark the buffer boundaries in the fringes
(setq-default indicate-buffer-boundaries 'left)

;; Highlight trailing empty lines and whitespace
(setq-default indicate-empty-lines t)
(setq-default show-trailing-whitespace t)

;; Enable AnsiColor for the shell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Display time
(setq display-time-day-and-date t) ; Display time and date
(setq display-time-24hr-format t)  ; Display the time in 24hr format
(display-time-mode t)

(defun initialise-layout-parameters ()
  (setq layout-hash (make-hash-table :test 'equal))

  ;; Set the size and x,y position of the initial and default emacs frames
  (puthash "top" 0 layout-hash)
  (puthash "left" 0 layout-hash)
  (puthash "width" 80 layout-hash)
  (puthash "height" 40 layout-hash)
  (puthash "vertical-scroll-bars" "right" layout-hash)

  ;; Set the default frame colours and fonts
  (puthash "foreground-color" "white" layout-hash)
  (puthash "background-color" "black" layout-hash)
  (puthash "cursor-color" "white" layout-hash)
  (puthash "font" "dejavu sans mono-10" layout-hash))

(initialise-layout-parameters)
(if (fboundp 'custom-frame-layout) (custom-frame-layout))

;; Set the default layout of emacs frames
(setq default-frame-alist
      `((top . ,(gethash "top" layout-hash))
        (left . ,(gethash "left" layout-hash))
        (width . ,(gethash "width" layout-hash))
        (height . ,(gethash "height" layout-hash))
        (vertical-scroll-bars . ,(gethash "vertical-scroll-bars" layout-hash))
        (foreground-color . ,(gethash "foreground-color" layout-hash))
        (background-color . ,(gethash "background-color" layout-hash))
        (cursor-color . ,(gethash "cursor-color" layout-hash))
        (font . ,(gethash "font" layout-hash))))



;;
;; Behaviour
;;

;; Suppress the start-up screen
(setq inhibit-startup-screen t)

;; Confirm before exiting emacs
(if (boundp 'confirm-kill-emacs)
    (setq confirm-kill-emacs 'yes-or-no-p))

;; Highlight matching parentheses
(show-paren-mode t)

;; Always use spaces to indent, no tab
(set-default 'indent-tabs-mode nil)

;; start the emacs server automatically
(server-start)



;;
;; Tools
;;

;; Enable ido mode
(use-package ido
  :ensure t
  :init
  (ido-mode t)
  ;; enable fuzzy matching
  (setq ido-enable-flex-matching t))
;; Enable smex mode
(use-package smex
  :ensure t
  :bind
  ("M-x" . smex)
  ("M-X" . smex-major-mode-commands))

;; Enable undo-tree
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode t)
  :bind
  ("C-z" . undo)
  ("C-M-Z" . undo-tree-redo))

;; Enable auto-complete
(use-package auto-complete
  :ensure t
  :config
  (global-auto-complete-mode t))

;; Highlight text that extends beyond a certain column
(use-package column-enforce-mode
  :ensure t
  :config
  (global-column-enforce-mode t))

;; Draw a line to indicate 80 column mark
(use-package fill-column-indicator
  :ensure t
  :init
  (define-globalized-minor-mode global-fci-mode fci-mode turn-on-fci-mode)
  (global-fci-mode t)
  (setq-default fill-column 80)
  (setq fci-rule-character ?│)
  (setq fci-rule-character-color "grey15"))

;; Enable org-mode
(use-package org-mode
  :init
  ;; Automatically activate org-mode for files with a .org and .txt extension
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))

  ;; Capture timestamps when TODO state changes
  (setq org-log-done t)

  ;; Make org-mode files indent nicely (pretty view)
  (setq org-startup-indented t)

  ;; Initialise any custom org variables
  (if (fboundp 'org-variables) (org-variables))

  ;; Use org-latex
  ;;(require 'org-latex)

  (use-package org-crypt
    :config
    (org-crypt-use-before-save-magic)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))
    ;; Disable auto-save-mode to prevent data being auto-saved in plain text
    (setq org-crypt-disable-auto-save t)
    ;; GPG Key used for encryption (defaults to nil for symmetric encryption)
    (setq org-crypt-key (if (boundp 'gpg-key-id) gpg-key-id nil)))

  ;; Use gnuplot
  (use-package gnuplot
    :ensure t)

  :bind
  ("C-c a" . org-agenda)
  ("C-c b" . org-iswitchb)
  ("C-c l" . org-store-link)
  ("C-c c" . org-capture)
  ("M-C-g" . org-plot/gnuplot))


;; ERC IRC Client
;;(require 'erc-nick-notify)
(use-package erc
  :init
  (setq irc-servers (list))

  ;; Create individual hash-tables with parameters for each irc server
  ;; to be connected and add the <SERVER-NAME> to 'irc-servers
  ;; Example:
  ;;  (setq <SERVER-NAME> (make-hash-table :test 'equal))
  ;;  (puthash "server" "<SERVER-FQDN>" <SERVER-NAME>)      [REQUIRED]
  ;;  (puthash "port" 6667 <SERVER-NAME>)                   [REQUIRED]
  ;;  (puthash "password-prefix" "<PREFIX>" <SERVER-NAME>)  [OPTIONAL]
  ;;  (puthash "nick" "<NICK>" <SERVER-NAME>)               [OPTIONAL]
  ;;  (puthash "full-name" "<FULL-NAME>" <SERVER-NAME>)     [OPTIONAL]
  ;;  (add-to-list 'irc-servers <SERVER-NAME>)

  ;; Initialise any custom variables
  (if (fboundp 'erc-variables) (erc-variables))

  :config
  ;; Check channels
  ;; (erc-track-mode t)
  ;; Exclude some types of messages including messages sent by the server
  ;; when joining a channel, such as the nicklist and topic
  (setq erc-track-exclude-types '("NICK" "JOIN" "PART" "QUIT" "MODE"
                                  "301" ; Away notice
                                  "305" ; Return from being away
                                  "306" ; Mark as being away
                                  "324" ; Modes
                                  "329" ; Channel creation date
                                  "332" ; Channel topic notice
                                  "333" ; Who set the channel topic
                                  "353" ; Names notice
                                  "477" ; Channel unsupported modes
                                  ))
  ;; Don't show any of these messages
  ;; (setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))
  ;; Don't track server buffer
  (setq erc-track-exclude-server-buffer t)
  ;; Don't track some channels/query targets
  (setq erc-track-exclude '("*stickychan" "*status"))
  ;; Show modified channel information after the global-mode-string
  (setq erc-track-position-in-mode-line t)
  ;; Show the count of unseen messages for each channel
  (setq erc-track-showcount t)

  ;; Track query buffers as if they contain the current nick
  ;; to allow private messages to be treated with urgency
  (defadvice
      erc-track-find-face
      (around erc-track-find-face-promote-query activate)
    (if (erc-query-buffer-p)
        (setq ad-return-value (intern "erc-current-nick-face"))
      ad-do-it))

  (defun erc-start-or-switch ()
    "Connect to ERC, or switch to last active buffer"
    (interactive)
    (if (delq nil (mapcar
                   (lambda (x) (and (erc-server-buffer-p x) x))
                   (buffer-list)))  ;; ERC already active?
        (erc-track-switch-buffer 1)  ;; yes: switch to last active
      (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
        (if irc-servers
            (dolist (irc-server irc-servers)
              (when (y-or-n-p (format "Connect to %s?"
                                      (gethash "server" irc-server)))
                (erc
                 :server (gethash "server" irc-server)
                 :port (gethash "port" irc-server)
                 :password (if (gethash "password-prefix" irc-server)
                               (concat
                                (gethash "password-prefix" irc-server)
                                (read-passwd (concat
                                              (gethash "server" irc-server)
                                              " password: "))))
                 :nick (if (gethash "nick" irc-server)
                           (gethash "nick" irc-server)
                         (read-string "Nick: "))
                 :full-name (if (gethash "full-name" irc-server)
                                (gethash "full-name" irc-server)
                              "_"))))
          (call-interactively 'erc-select)))))

  (defun erc-stop ()
    "Disconnect from IRC servers."
    (interactive)
    (dolist (buffer (erc-buffer-list))
      (when (erc-server-buffer-p buffer)
        (set-buffer buffer)
        (erc-quit-server "Quit")
        (kill-buffer buffer))))

  ;; Improve scrolling in channel buffers
  (add-to-list 'erc-mode-hook
               (lambda ()
                 (set (make-local-variable 'scroll-conservatively) 100)))


  ;; Kill buffers for channels after /part
  (setq erc-kill-buffer-on-part t)
  ;; Kill buffers for private queries after quitting the server
  (setq erc-kill-queries-on-quit t)
  ;; Kill buffers for server messages after quitting the server
  (setq erc-kill-server-buffer-on-quit t)

  :bind
  ("C-c e" . erc-start-or-switch)
  ("C-c E" . erc-stop))

;; Enable google-this
;; https://github.com/Malabarba/emacs-google-this
(use-package google-this
  :ensure t
  :init
  (google-this-mode t))


;;
;; Programming
;;
(use-package elpy
  :ensure t
  :init
  (elpy-enable))
(use-package yaml-mode
  :ensure t)
(use-package json-mode
  :ensure t)


;;
;; Emacs auto-configured items from: M-x customize (DO NOT TOUCH!!!)
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(error ((t (:foreground "Red" :weight bold))))
 '(hl-line ((t (:background "gray10"))))
 '(linum ((t (:inherit shadow :background "grey10"))))
 '(trailing-whitespace ((t (:background "grey20"))))
 )
