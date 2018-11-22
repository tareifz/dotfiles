
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
                                       (setq-default linum-format " %d ")))))

(fset 'yes-or-no-p 'y-or-n-p)

(show-paren-mode t)

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

(progn
  ;; make buffer switch command do suggestions, also for find-file command
  (require 'ido)
  (ido-mode 1)

  ;; show choices vertically
  (if (version< emacs-version "25")
      (progn
        (make-local-variable 'ido-separator)
        (setq ido-decorations "\n"))
    (progn
      (make-local-variable 'ido-decorations)
      (setf (nth 2 ido-decorations) "\n")))

  ;; show any name that has the chars you typed
  (setq ido-enable-flex-matching t)
  ;; use current pane for newly opened file
  (setq ido-default-file-method 'selected-window)
  ;; use current pane for newly switched buffer
  (setq ido-default-buffer-method 'selected-window)
  ;; stop ido from suggesting when naming new file
  (define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil))

;; big minibuffer height, for ido to show choices vertically
(setq max-mini-window-height 0.5)

(require 'ido)
;; stop ido suggestion when doing a save-as
(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)

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

;; (use-package sourcerer-theme)
;; (use-package dracula-theme)
;; (use-package atom-one-dark-theme)
(use-package hydandata-light-theme)

(use-package org)

(use-package try)

(use-package rainbow-delimiters
  :requires rainbow-mode
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode t))

(use-package smex
  :bind (("M-x" . smex))
  :config (smex-initialize))

(use-package switch-window
  :config
  (global-set-key (kbd "C-x o") 'switch-window))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))
