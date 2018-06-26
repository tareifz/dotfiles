;;; package --- summery
;;; Commentary:

;; ############################################ :;
;; ######## Packages & Package Manager ######## ;;
;; ############################################ ;;

;;; Code:
;; ---------- Initializing ---------- ;;
(require 'package)
(setq package-archives
			'(("gnu" . "http://elpa.gnu.org/packages/")
				("marmalade" . "http://marmalade-repo.org/packages/")
				("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
	(progn
		(package-refresh-contents)
		(package-install 'use-package)))

(require 'use-package)
(require 'bind-key)

;; install packages if not in the system.
(setq use-package-always-ensure t)

;; auto-close parens.
(use-package smartparens
	:config
	(smartparens-global-mode t))

;; represent colors with the color they represent as background.
(use-package rainbow-mode
	:config
	(add-hook 'prog-mode-hook #'rainbow-mode))

;; rainbow parentheses.
(use-package rainbow-delimiters
	:requires rainbow-mode
	:config
	(add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; minor mode that keeps your code always indented.
(use-package aggressive-indent
	:config
	(global-aggressive-indent-mode t))

;; shows the cursor position.
(use-package beacon
	:custom
	(beacon-mode t "turn on beacon mode.")
	(beacon-blink-when-focused t "let the cursor blink when focused."))

;; commands bar auto complete and suggestion.
(use-package smex
	:bind (("M-x" . smex))
	:config (smex-initialize))

;; auto-complete engine.
(use-package company
	:config
	(global-company-mode t))

;; rust-lang support.
(use-package rust-mode
	:custom (company-tooltip-align-annotations t))

;; provide rust code completion with Company.
;; rustup component add rust-src
;; cargo install racer
(use-package racer
	:requires rust-mode
	:config
	(add-hook 'rust-mode-hook #'racer-mode)
	(add-hook 'racer-mode-hook #'eldoc-mode))

;; (use-package sourcerer-theme)
;; (use-package prassee-theme)
;; (use-package dracula-theme)
;; (use-package atom-one-dark-theme)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-file "~/.emacs.d/themes/tareifz-basic-theme.el")

(defun load-only-theme ()
	"Disable all themes and then load a single theme interactively."
	(interactive)
	(while custom-enabled-themes
		(disable-theme (car custom-enabled-themes)))
	(call-interactively 'load-theme))

(use-package org)

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

;; good feature but annoying some times.
;; (use-package symon
;;	:config
;;	(symon-mode 1))

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
;; (use-package flycheck-inline
;;	:requires (flycheck)
;;	:config	(flycheck-inline-mode 1))

(use-package flycheck-rust
	:requires (flycheck)
	:hook (rust-mode . flycheck-rust-setup))


;; ############################################ ;;
;; ############# Custom Functions ############# ;;
;; ############################################ ;;
(defun tareifz-kill-line ()
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

;; ############################################ ;;
;; ############# Editer User Info ############# ;;
;; ############################################ ;;
(setq user-full-name "Tareif Al-Zamil")
(setq user-mail-address "root@tareifz.me")

;; ############################################ ;;
;; ######### Editer General Settings ########## ;;
;; ############################################ ;;
;; Ask "y" or "n" instead of "yes" or "no". Yes, laziness is great.
(fset 'yes-or-no-p 'y-or-n-p)
;; Highlight corresponding parentheses when cursor is on one
(show-paren-mode t)
;; Highlight tabulations
(setq-default highlight-tabs t)
;; Show trailing white spaces
(setq-default show-trailing-whitespace t)
;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))
;; Skip splash screen
(setq inhibit-splash-screen t
			initial-scratch-message nil
			initial-major-mode 'org-mode)
;; Show empty line markers
;;(setq-default indicate-empty-lines t)
;;(when (not indicate-empty-lines)
;;(toggle-indicate-empty-lines))

;; Make ibuffer default
(defalias 'list-buffers 'ibuffer)

;; Keep a list of recently opened files
(recentf-mode 1)
;; Set F7 to list recently opened files
(global-set-key (kbd "<f7>") 'recentf-open-files)

;; Save/restore opened files and windows configurations
(desktop-save-mode 1)

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;; turn on highlighting current line
(global-hl-line-mode 1)

;; when a file is updated outside emacs, make it update if it's already opened in emacs
(global-auto-revert-mode 1)

(defun my-prettify-symbols-list ()
	"Make some word or string show as pretty Unicode symbols."
	(setq prettify-symbols-alist
				'(
					("lambda" . 955) ;; λ
					("->" . 8594)    ;; →
					("=>" . 8658)    ;; ⇒
					("<=" . 8804)		 ;; ≤
					(">=" . 8805)		 ;; ≥
					("!=" . 8800)		 ;; ≠
					("===" . 8801)	 ;; ≡
					("!==" . 8802)	 ;; ≢
					)))

(add-hook 'prog-mode-hook 'my-prettify-symbols-list)

;; display “lambda” as “λ”
(global-prettify-symbols-mode 1)

;; override [C-k] (kill-to-end-of-line)
;; the bind-key* (with star) will override key bindings in all minor modes
(bind-key* "C-k" 'tareifz-kill-line)
;; ############################################ ;;
;; ################ Tabs Setup ################ ;;
;; ############################################ ;;
;; Indent using 2 spaces tab
(setq-default tab-width 2)

;; insert literal tab instead of invoking indentation command
;; (defun my-insert-tab-char ()
;;	"Insert a tab char. (ASCII 9, \t)"
;;	(interactive)
;;	(insert "\t"))

;; (global-set-key (kbd "<tab>") 'my-insert-tab-char) ; same as Ctrl+i
;; make tab key call indent command or insert tab character, depending on cursor position
;; (setq-default tab-always-indent nil)
;; ############################################ ;;
;; ############## Ido Mode Setup ############## ;;
;; ############################################ ;;
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

;; ############################################ ;;
;; ############### Backup Files ############### ;;
;; ############################################ ;;
;; Remove all backup files
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

;; ############################################ ;;
;; ############## Files Encoding ############## ;;
;; ############################################ ;;
;; Set locale to UTF8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; ############################################ ;;
;; ############# Globel Variables ############# ;;
;; ############################################ ;;

;; Disable menu bar
(menu-bar-mode -1)
;; Disable tool bar
(tool-bar-mode -1)
;; Disable scroll bar
(toggle-scroll-bar -1)
;; Display line number
(global-linum-mode t)
;; Every time bookmark is changed, automatically save it
(setq bookmark-save-flag 1)
;; font settings
;; (set-frame-font "Ubuntu Mono")
;; (set-frame-font "More Perfect DOS VGA")
;; (set-frame-font "Unifont")
(set-frame-font "Dejavu Sans Mono")

;;; init.el ends here.
