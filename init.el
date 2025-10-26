(require 'org-element)
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
;; Everything should go after this

(setq org-noter-notes-search-path '("/home/amitav/org/roam/notes")
      org-noter-create-notes-file-if-missing t
      org-noter-always-create-notes-file t
      org-noter-notes-window-location 'horizontal-split)

(use-package org-noter
  :after org
  :config
  (setq org-noter-notes-search-path '("/home/amitav/org/roam/notes")
        org-noter-create-notes-file-if-missing t
        org-noter-auto-save-last-location t))


(setq enabled-option t
      disabled-option nil

      enabled-mode 1
      disabled-mode 0)

(setq inhibit-startup-screen t)

(defun my/get-org (file)
  "Return a list of items from an org-mode file."
  (with-temp-buffer
    (insert-file-contents file)

    (let (items)
      (org-element-map (org-element-parse-buffer) 'headline
          
        (lambda (hl)
          (let* ((title (org-element-property :raw-value hl))
                 (content (org-element-interpret-data (org-element-contents hl)))
		 (bold-title (propertize title 'face 'bold)))
	    
            (push (format "*%s*\n\n%s" bold-title (string-trim content)) items))))
      (nreverse items))))

(defun my/get-daily-quote (file)
  "Return the same quote for each day from FILE, or a fallback message."
  (let ((quotes (my/get-org file)))
    (if (null quotes)
        (with-temp-buffer
	  (insert-file-contents file)
	  (buffer-string))
      (let* ((day-num (string-to-number (format-time-string "%j"))) ;; 1–366
             (index (% day-num (length quotes))))
        (nth index quotes)))))

(defun my-dashboard ()
  "Show a simple hello world dashboard with a daily quote."
  (switch-to-buffer "*dashboard*")
  (erase-buffer)


  (insert "------------------------------------------------\n")
  (insert "  This is ")
  "Rainbow Amitav Krishna"
  (let* ((name "Amitav Krishna")
	 
	 (colors ["red" "orange" "yellow" "cyan"]))
	 (dotimes (i (length name))
	   (let ((char (substring name i (1+ i)))
		 (color (aref colors (% i (length colors)))))
	     (insert (propertize char 'face `(:foreground ,color))))))

  (insert "\'s Emacs dashboard\n")	;
	 

  (insert "------------------------------------------------\n\n")

  (insert-text-button "Quote"
		      `action (lambda (_) (find-file"~/org/notes/Quotes.org")))
  (insert " of the day:\n\n")
  (insert (my/get-daily-quote "~/org/notes/Quotes.org"))
  (insert "\n\n")


  (insert "Quick links:\n")
  (insert-text-button "Init file"
                     'action (lambda (_) (find-file user-init-file)))
  (insert "\n")
    (insert-text-button "Notes"
                     'action (lambda (_) (find-file "~/org/notes/")))
    (insert "\n")
      (insert-text-button "references.bib"
                     'action (lambda (_) (find-file "~/books/references.bib")))
  (insert "\n")
  
  (insert-text-button "Programming"
                      'action (lambda (_) (find-file "~/codage")))
  (insert "\n")
  (insert-text-button "Blogs"
                      'action (lambda (_) (find-file "~/blogs")))
  (insert "\n")
  (insert-text-button "Captures"
                      'action (lambda (_) (find-file "~/org/notes/capture.org")))
  (insert "\n")
  (my-dashboard-mode 1)
  

  ;; Finish
  (goto-char (point-min))

  (setq truncate-lines nil)
  (read-only-mode 1))
(defun my/dashboard-goto-init_file ()
  (interactive)
  (when (string= (buffer-name) "*dashboard*")
    (goto-char (point-min))
    (when (search-forward "Init file" nil t)
      (beginning-of-line))))
(defun my/dashboard-goto-blogs ()
  (interactive)
  (when (string= (buffer-name) "*dashboard*")
    (goto-char (point-min))
    (when (search-forward "Blogs" nil t)
      (beginning-of-line))))
(defun my/dashboard-goto-notes ()
  (interactive)
  (when (string= (buffer-name) "*dashboard*")
    (goto-char (point-min))
    (when (search-forward "Notes" nil t)
      (beginning-of-line))))
(defun my/dashboard-goto-programming ()
  (interactive)
  (when (string= (buffer-name) "*dashboard*")
    (goto-char (point-min))
    (when (search-forward "Programming" nil t)
      (beginning-of-line))))
(defun my/dashboard-goto-references ()
  (interactive)
  (when (string= (buffer-name) "*dashboard*")
    (goto-char (point-min))
    (when (search-forward "references.bib" nil t)
      (beginning-of-line))))

(defun my/dashboard-goto-captures ()
  (interactive)
  (when (string= (buffer-name) "*dashboard*")
    (goto-char (point-min))
    (when (search-forward "Captures" nil t)
      (beginning-of-line))))



(defvar my-dashboard-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "i") 'my/dashboard-goto-init_file)
    (define-key map (kbd "r") 'my/dashboard-goto-references)
    (define-key map (kbd "b") 'my/dashboard-goto-blogs)
    (define-key map (kbd "p") 'my/dashboard-goto-programming)
    (define-key map (kbd "n") 'my/dashboard-goto-notes)
    (define-key map (kbd "c") 'my/dashboard-goto-captures)
    map)
  "Keymap for `my-dashboard-mode'.")

(define-minor-mode my-dashboard-mode
  "Minor mode for my custom Emacs dashboard."
  :keymap my-dashboard-mode-map
  :init-value nil
  (read-only-mode 1))

(add-hook 'emacs-startup-hook 'my-dashboard)

;; UI cleanup
(tool-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode 0)
(blink-cursor-mode 0)
(add-to-list 'default-frame-alist '(background-color . "#282A36"))
(add-to-list 'default-frame-alist '(foreground-color . "#F0EAD6"))
(add-to-list 'default-frame-alist '(font . "Monospace-8"))
(display-time-mode 1)
(set-frame-parameter nil 'background-color "#282A36")
(set-frame-parameter nil 'foreground-color "#F0EAD6")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (C . t)
   (python . t)
   (jupyter . t)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
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


