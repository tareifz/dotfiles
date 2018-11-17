
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

(desktop-save-mode 1)

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

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (load-file "~/.emacs.d/themes/tareifz-basic-theme.el")
;; (load-file "~/.emacs.d/themes/tareifz-shadows-theme.el")

;; (use-package sourcerer-theme)
;; (use-package dracula-theme)
;; (use-package atom-one-dark-theme)
(use-package hydandata-light-theme)

(use-package org)

(use-package try)

(use-package smartparens
  :config
  (smartparens-global-mode t))

(use-package rainbow-mode
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

(use-package rainbow-delimiters
  :requires rainbow-mode
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode t))

(use-package beacon
  :custom
  (beacon-mode t "turn on beacon mode.")
  (beacon-blink-when-focused t "let the cursor blink when focused."))

(use-package smex
  :bind (("M-x" . smex))
  :config (smex-initialize))

(use-package company
  :config
  (global-company-mode t))

(use-package rust-mode
  :custom
  (company-tooltip-align-annotations t))

;; rustup component add rust-src
;; cargo install racer
(use-package racer
  :requires rust-mode
  :config
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package switch-window
  :config
  (global-set-key (kbd "C-x o") 'switch-window))

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

(use-package electric-operator
  :config
  (add-hook 'rust-mode-hook #'electric-operator-mode)
  (add-hook 'javascript-mode-hook #'electric-operator-mode)
  (electric-operator-add-rules-for-mode 'rust-mode
                                        (cons "->" " -> ")))

;; M-x httpd-start
;; M-x impatient-mode
;; http://localhost:8080/imp/
(use-package impatient-mode)

(use-package all-the-icons)
;; M-x all-the-icons-install-fonts

(use-package neotree
  :bind(("<f5>" . neotree-toggle))
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq-default neo-show-hidden-files t))

(use-package telephone-line
  :config
  (telephone-line-mode 1))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode))

;; annoying with long error messages (rustc errors)
(use-package flycheck-inline
  :requires (flycheck)
  :config (flycheck-inline-mode 1))

(use-package flycheck-rust
  :requires (flycheck)
  :hook (rust-mode . flycheck-rust-setup))

;; C-c C-b === eval-buffer
;; C-c C-c === eval-definition.
(use-package geiser
  :config
  (setq geiser-active-implementations '(guile)))

(use-package flymd
  :config
  (setq-default flymd-output-directory "~/.flymd/"))

(use-package helm
  :init
  (setq helm-mode-fuzzy-match        t
        helm-buffers-fuzzy-matching  t
        helm-recentf-fuzzy-match     t
        helm-M-x-fuzzy-match         t
        helm-full-frame              nil
        helm-ff-guess-ffap-urls      nil
        helm-ff-guess-ffap-filenames nil
        helm-highlight-matches-around-point-max-lines 0)
  :bind (("M-x" . helm-M-x)
         ("C-x b" . helm-buffers-list)
         ("C-x C-f" . helm-find-files)
         ("C-x C-d" . helm-browse-project)
         ("C-c f" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
         :map helm-map
         ("<tab>" . helm-execute-persistent-action) ;; make tab complete action
         ("C-i" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)
         ))

;;(global-set-key (kbd "<f5> s")                       'helm-find)

(use-package helm-ls-git
  :requires (helm))

;; [C-j] to expand
(use-package emmet-mode
  :hook (web-mode . emmet-mode))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))
