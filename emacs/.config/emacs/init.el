;;; package --- Summary

;;; Commentary:
;;; Tareifz Emacs config

(require 'package)

;;; Code:
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

(require 'use-package)
(require 'bind-key)

(setq use-package-always-ensure t)

(use-package emacs
  :config
  ;; General Emacs configs
  (setq user-full-name "Tareif Al-Zamil"
        user-mail-address "root@tareifz.me"
        inhibit-splash-screen 1
        initial-scratch-message nil
        initial-major-mode 'lisp-mode
        bookmark-save-flag 1
        make-backup-files nil
        backup-inhibited t
        auto-save-default nil)
  ;; Set UTF-8 encoding.
  (set-language-environment 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  ;; y or n
  (fset 'yes-or-no-p 'y-or-n-p)
  ;; use ibuffer
  (defalias 'list-buffers 'ibuffer)
  ;;
  (electric-pair-mode 1)
  (show-paren-mode t)
  (delete-selection-mode 1)
  (global-hl-line-mode 1)
  (global-auto-revert-mode 1)
  ;; (global-linum-mode t)
  (global-display-line-numbers-mode)
  ;;
  (setq-default linum-format " %d "
                ring-bell-function 'ignore
                indent-tabs-mode nil
                highlight-tabs t
                show-trailing-whitespace t
                tab-width 2
                default-tab-width 2
                tab-always-indent nil
                ;; Javescript indent level
                js-indent-level 2
                ;; Custom settings file
                custom-file "~/.config/emacs/auto-generated-customized-settings.el")
  (unless (file-exists-p custom-file)
    (with-temp-buffer (write-file custom-file)))
  (load-file custom-file)

  (if (daemonp)
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (select-frame frame)
                  (tz/set-ui))))

  ;; Set the UI
  (tz/set-ui)
  :hook ((before-save . whitespace-cleanup)
         (before-save . (lambda () (delete-trailing-whitespace)))
         (crystal-mode . insert-crystal-template))
  :preface
  (defun tz/set-ui ()
    "Set UI settings (fonts, hide bars, ...)"
    (interactive)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (toggle-scroll-bar -1)
    ;; (set-frame-font "GohuFont:pixelsize=14")
    ;; (set-frame-font "Terminus:pixelsize=16")
    (set-frame-font "Fira Code:pixelsize=16")
    (set-face-attribute 'default nil :height 160 :weight 'semibold))

  (defun tz/load-only-theme ()
    "Disable all themes and then load a single theme interactively."
    (interactive)
    (while custom-enabled-themes
      (disable-theme (car custom-enabled-themes)))
    (call-interactively 'load-theme))

  (defun insert-crystal-template()
    (when (= (point-max) (point-min))
      (insert-file-contents "~/.config/emacs/templates/crystal.cr"))))

(use-package try)

(use-package rainbow-mode
  :diminish t
  :hook (prog-mode . rainbow-mode)
  :config
  (setq rainbow-x-colors nil))

(use-package rainbow-delimiters
  :requires rainbow-mode
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq lsp-completion-provider :capf)
  :custom
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t))

(use-package rust-mode)
(use-package typescript-mode)
(use-package crystal-mode)
(use-package fish-mode)
(use-package yaml-mode)
(use-package toml-mode)

(use-package multiple-cursors
  :bind
  ("C->" . mc/mark-next-like-this)
  ("C-<" . mc/mark-previous-like-this)
  ("C-c C-<" . mc/mark-all-like-this))

(use-package switch-window
  :bind
  ("C-x o" . switch-window))

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
  :hook
  (flycheck-mode . flycheck-rust-setup))

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(use-package hl-todo
  :config
  (global-hl-todo-mode))

(use-package hlinum
  :config
  (hlinum-activate))

(use-package docker
  :ensure t
  :bind ("C-c d" . docker))

(use-package yascroll
  :config
  (global-yascroll-bar-mode 1))

;; install -> yay rust-analyzer
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((rust-mode . lsp)
   (typescript-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-rust-server 'rust-analyzer
        lsp-completion-enable-additional-text-edit nil))

(use-package lsp-ui)
(use-package lsp-java
  :hook (java-mode . lsp))
(use-package lsp-treemacs)
(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)

(use-package auto-package-update
  :config
  (auto-package-update-maybe))

(use-package restclient
  :config
    (add-to-list 'auto-mode-alist '("\\.restclient\\'" . restclient-mode)))

(use-package ivy
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  (ivy-mode 1))

(use-package counsel
  :config
  (counsel-mode))

(use-package highlight-thing
  :hook
  (prog-mode . highlight-thing-mode))

(use-package paredit
  :hook
  (emacs-lisp-mode . paredit-mode)
  (lisp-mode . paredit-mode)
  (scheme-mode . paredit-mode))

(use-package aggressive-indent
  :hook
  (emacs-lisp-mode . aggressive-indent-mode)
  (lisp-mode . aggressive-indent-mode)
  (scheme-mode . aggressive-indent-mode)
  (sly-mode . aggressive-indent-mode))

(use-package ef-themes
  :config
  (load-theme 'ef-summer t))

(use-package sly)

;;; init.el ends here
