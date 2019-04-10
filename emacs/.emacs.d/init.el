(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("marmalade" . "https://marmalade-repo.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

(require 'use-package)

(require 'bind-key)

(setq use-package-always-ensure t)

(setq user-full-name "Tareif Al-Zamil"
      user-mail-address "root@tareifz.me")

(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;; save & shutdown when we get an "end of session" signal on dbus
(require 'dbus)

(defun my-register-signals (client-path)
  "Register for the 'QueryEndSession' and 'EndSession' signals from
Gnome SessionManager.

When we receive 'QueryEndSession', we just respond with
'EndSessionResponse(true, \"\")'.  When we receive 'EndSession', we
append this EndSessionResponse to kill-emacs-hook, and then call
kill-emacs.  This way, we can shut down the Emacs daemon cleanly
before we send our 'ok' to the SessionManager."
  (setq my-gnome-client-path client-path)
  (let ( (end-session-response (lambda (&optional arg)
                                 (dbus-call-method-asynchronously
                                  :session "org.gnome.SessionManager" my-gnome-client-path
                                  "org.gnome.SessionManager.ClientPrivate" "EndSessionResponse" nil
                                  t "") ) ) )
         (dbus-register-signal
          :session "org.gnome.SessionManager" my-gnome-client-path
          "org.gnome.SessionManager.ClientPrivate" "QueryEndSession"
          end-session-response )
         (dbus-register-signal
          :session "org.gnome.SessionManager" my-gnome-client-path
          "org.gnome.SessionManager.ClientPrivate" "EndSession"
          `(lambda (arg)
             (add-hook 'kill-emacs-hook ,end-session-response t)
             (kill-emacs) ) ) ) )

;; DESKTOP_AUTOSTART_ID is set by the Gnome desktop manager when emacs
;; is autostarted.  We can use it to register as a client with gnome
;; SessionManager.
(dbus-call-method-asynchronously
 :session "org.gnome.SessionManager"
 "/org/gnome/SessionManager"
 "org.gnome.SessionManager" "RegisterClient" 'my-register-signals
 "Emacs server" (getenv "DESKTOP_AUTOSTART_ID"))

(add-hook 'after-make-frame-functions
          (lambda (frame)
                  (with-selected-frame frame
                                       (progn (menu-bar-mode -1)
                                       (tool-bar-mode -1)
                                       (toggle-scroll-bar -1)
                                       (global-linum-mode t)
                                       (setq-default linum-format " %d ")
                                       ;;(set-frame-font "Terminus:antialias=none")
                                       ;;(set-face-attribute 'default nil :height 120)
                                       (set-frame-font "Hack")
                                       (set-face-attribute 'default nil :height 160)))))

(fset 'yes-or-no-p 'y-or-n-p)

(show-paren-mode t)

(electric-pair-mode t)

(setq-default highlight-tabs t)

(setq-default show-trailing-whitespace t)

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

(defalias 'list-buffers 'ibuffer)

(delete-selection-mode 1)

(global-hl-line-mode 1)

(global-auto-revert-mode 1)

(defun my-prettify-symbols-list ()
  "Make some word or string show as pretty Unicode symbols."
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955) ;; λ
          ("->" . 8594)    ;; →
          ("=>" . 8658)    ;; ⇒
          ("<=" . 8804)    ;; ≤
          (">=" . 8805)    ;; ≥
          ("!=" . 8800)    ;; ≠
          ("===" . 8801)   ;; ≡
          ("!==" . 8802)   ;; ≢
          )))

(add-hook 'prog-mode-hook 'my-prettify-symbols-list)

;; display “lambda” as “λ”
(global-prettify-symbols-mode 1)

(setq-default indent-tabs-mode nil)

(setq-default tab-width 2)
(setq-default default-tab-width 2)

(setq-default js-indent-level 2)

(setq-default tab-always-indent nil)

(ido-mode 1)
(ido-everywhere 1)

(use-package ido-completing-read+
  :config
  (ido-ubiquitous-mode 1))

(use-package ido-vertical-mode
  :config
  (ido-vertical-mode 1)
  :custom
  (ido-vertical-define-keys 'C-n-and-C-p-only))

(use-package flx-ido
  :config
  (flx-ido-mode 1)
  :custom
  (ido-enable-flex-matching t)
  (ido-use-faces nil))

(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(menu-bar-mode -1)

(tool-bar-mode -1)

(toggle-scroll-bar -1)

(global-linum-mode t)
(setq-default linum-format " %d ")

(setq bookmark-save-flag 1)

;; (set-frame-font "Ubuntu Mono")
;; (set-frame-font "More Perfect DOS VGA")
;; (set-frame-font "Unifont")
;; (set-frame-font "Terminus:antialias=none")
;; (set-face-attribute 'default nil :height 120)
;; (set-frame-font "Monaco")
(set-frame-font "Hack")
(set-face-attribute 'default nil :height 120)

(setq-default custom-file "~/.emacs.d/auto-generated-customized-settings.el")
(load-file custom-file)

(defun tareifz/load-only-theme ()
  "Disable all themes and then load a single theme interactively."
  (interactive)
  (while custom-enabled-themes
    (disable-theme (car custom-enabled-themes)))
  (call-interactively 'load-theme))

(defun tareifz/kill-line ()
  "Killing current line with the new line character, and put the cursor at the beginning of the line."
  (interactive)
  (let (line-begin line-end)
    (setq line-begin (line-beginning-position))
    (setq line-end (if (= (point-max) (line-end-position))
                       (progn
                         (line-end-position))
                     (progn
                       (forward-line 1)
                       (line-beginning-position))))
    (kill-region line-begin line-end)
    (beginning-of-line))
  )

(bind-key* "C-k" 'tareifz/kill-line)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (load-file "~/.emacs.d/themes/tareifz-basic-theme.el")
;; (load-file "~/.emacs.d/themes/tareifz-shadows-theme.el")

;; (use-package sourcerer-theme)
;; (use-package dracula-theme)
;; (use-package atom-one-dark-theme)
;; (use-package hydandata-light-theme)
;; (use-package panda-theme)
(use-package hemera-theme)

(use-package org)

(use-package try)

(use-package rainbow-mode
  :hook
  (prog-mode . rainbow-mode))

(use-package rainbow-delimiters
  :requires rainbow-mode
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package aggressive-indent
  :hook
  (prog-mode . aggressive-indent-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t))

(use-package rust-mode)

;; rustup component add rust-src
;; cargo install racer
(use-package racer
  :requires rust-mode
  :hook
  ((rust-mode . racer-mode)
   (racer-mode . eldoc-mode)))

(use-package multiple-cursors
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

(use-package switch-window
  :bind
  ("C-x o" . switch-window))

(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))

(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

;; M-x httpd-start
;; M-x impatient-mode
;; http://localhost:8080/imp/
(use-package impatient-mode)

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode))

(use-package flycheck-rust
  :requires (flycheck rust-mode)
  :hook (rust-mode . flycheck-rust-setup))

(use-package flymd
  :custom
  (flymd-output-directory "~/.flymd/"))

;; [C-j] to expand
(use-package emmet-mode
  :hook (web-mode . emmet-mode))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(use-package prettier-js
  :hook (js2-mode . prettier-js-mode)
  :config
  (setq prettier-js-args '(
    "--trailing-comma" "es5")))

(use-package crystal-mode)

(use-package apib-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.apib\\'" . apib-mode)))

(use-package eyebrowse
  :config
  (eyebrowse-mode t))

(use-package indent-guide
  :config
  (indent-guide-global-mode))

(use-package all-the-icons)

(use-package neotree
  :bind
  ("<f5>" . neotree-toggle)
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
