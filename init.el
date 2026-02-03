;;; init.el --- Minimal Emacs config -*- lexical-binding: t; -*-

;; Package setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; --- Vertico + Consult (Telescope-like) ---
(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-c f" . consult-find)
         ("C-c g" . consult-ripgrep)
         ("C-c s" . consult-line))
  :custom
  (consult-preview-key "M-."))

;; --- Org-roam ---
(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam/notes/")
  (org-roam-completion-everywhere t)
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n c" . org-roam-capture))
  :config
  (org-roam-db-autosync-mode))

;; --- LSP Mode + Pyright ---
(use-package lsp-mode
  :hook ((python-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :bind (:map lsp-mode-map
         ("C-c d" . lsp-find-definition)
         ("C-c r" . lsp-find-references))
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-idle-delay 0.5)
  (lsp-log-io nil))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-sideline-show-diagnostics t))

;; Diagnostic navigation
(global-set-key (kbd "C-c e") 'flymake-show-buffer-diagnostics)
(global-set-key (kbd "M-n") 'flymake-goto-next-error)
(global-set-key (kbd "M-p") 'flymake-goto-prev-error)

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  :custom
  (lsp-pyright-typechecking-mode "strict"))

;; --- Vterm ---
(use-package vterm
  :bind ("C-c t" . vterm)
  :custom
  (vterm-max-scrollback 10000))

;; --- Magit ---
(use-package magit
  :bind ("C-x g" . magit-status))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-roam-ui magit vterm lsp-pyright lsp-ui lsp-mode org-roam)))
>>>>>>> fc6b599 (First commit from new device)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
<<<<<<< HEAD
(setq-default truncate-lines nil)
(define-key org-mode-map (kbd "C-u C-c C-l") 'org-toggle-link-display)
(flyspell-mode 1)
(setq org-confirm-babel-evaluate nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("~/notes/calendar.org"))
 '(package-selected-packages
   '(code-cells company counsel ein flycheck gptel htmlize ivy-bibtex
		jupyter latex-table-wizard lsp-treemacs lsp-ui magit
		org-noter org-roam-ui pdf-tools projectile subed vterm)))

(global-set-key (kbd "C-c b") 'ivy-bibtex)



;; Packages
(use-package deferred :ensure t)
(use-package request :ensure t)
(use-package ein
  :ensure t)
(use-package polymode
  :ensure t)
(use-package jupyter
  :ensure t)
(require 'ob-python)
(require 'ob-jupyter)
(use-package lsp-mode
  :ensure t
  :hook ((c++-mode . lsp)
         (c-mode . lsp))
  :commands lsp)
(use-package company
  :ensure t
  :hook (after-init . global-company-mode))
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode))
(use-package lsp-treemacs
  :ensure t
  :after lsp)
(use-package pdf-tools
  :ensure t
  :config (pdf-tools-install))

(use-package counsel
  :ensure t
  :after ivy
  :config (counsel-mode 1))

(use-package swiper
  :ensure t
  :after ivy)

(use-package ivy
  :ensure t
  :diminish
  :bind (("C-s" . swiper)               ;; search in buffer
         ("M-x" . counsel-M-x)          ;; better M-x
         ("C-x C-f" . counsel-find-file) ;; better file finder
         ("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t))
(use-package ivy-bibtex
  :ensure t
  :after ivy
  :config
  ;; Set the path to your .bib file
  (setq bibtex-completion-bibliography '("~/books/references.bib")
        bibtex-completion-library-path '("~/books/")
        bibtex-completion-notes-path "~/org/roam/notes/"
        bibtex-completion-pdf-field "file")
  ;; Optional: use ivy for completion
  (setq ivy-bibtex-default-action 'ivy-bibtex-open-any))



(unless (package-installed-p 'org-roam)
  (package-refresh-contents)
  (package-install 'org-roam))
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org/roam/notes/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))
(use-package gptel)
(load (expand-file-name "secrets.el" user-emacs-directory) t)
(gptel-make-deepseek "DeepSeek"       ;Any name you want
  :stream t                           ;for streaming responses
  :key deepseek-api-key)               ;can be a function that returns the key
;;; actual API key is in secrets.el which is in the .giignore so that I don't get pwned
;;; init.el ends here


