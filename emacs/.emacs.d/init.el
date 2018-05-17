;; ############################################ :;
;; ######## Packages & Package Manager ######## ;;
;; ############################################ ;;

;; ---------- Initializing ---------- ;;
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
												 ("marmalade" . "http://marmalade-repo.org/packages/")
												 ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
	(progn
		(package-refresh-contents)
		(package-install 'use-package)))

(require 'use-package)
;; install packages if not in the system.
(setq use-package-always-ensure t)

;; auto-complete engine.
(use-package company
	:config
	(global-company-mode t))

;; auto-close parens.
(use-package smartparens
	:config
	(smartparens-global-mode t))

;; minor mode that keeps your code always indented.
(use-package aggressive-indent
	:config
	(global-aggressive-indent-mode t))

;; shows the cursor position.
(use-package beacon
	:custom
	(beacon-mode t "turn on beacon mode.")
	(beacon-blink-when-focused t "let the cursor blink when focused."))

;; represent colors with the color they represent as background.
(use-package rainbow-mode
	:config
	(add-hook 'prog-mode-hook #'rainbow-mode))

;; rainbow parentheses.
(use-package rainbow-delimiters
	:requires rainbow-mode
	:config
	(add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; commands bar auto complete and suggestion.
(use-package smex
	:bind (("M-x" . smex))
	:config (smex-initialize))

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

(use-package sourcerer-theme)
(use-package prassee-theme)
(use-package dracula-theme)
(use-package org)

(use-package multiple-cursors
	:config
	(global-set-key (kbd "C->") 'mc/mark-next-like-this)
	(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
	(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package switch-window
	:config
	(global-set-key (kbd "C-x o") 'switch-window))

(add-to-list 'load-path' "~/.emacs.d/vendor/")
(require 'handlebars-mode)

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
				(setq ido-separator "\n"))
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
;; Indent using 2 spaces tab
(setq-default tab-width 2
							indent-tabs-mode t)
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
(set-default-font "More Perfect DOS VGA")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 (quote
		(prassee-theme soothe-theme firebelly switch-window use-package sourcerer-theme smex smartparens rainbow-mode rainbow-delimiters racer multiple-cursors company beacon aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
