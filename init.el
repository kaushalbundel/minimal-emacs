;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Startup & Performance (Set early!)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Increase GC threshold to speed up startup, then reset to a normal value
(setq gc-cons-threshold (* 100 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))

;; Speed up grep and LSP communication
(setq read-process-output-max (* 4 1024 1024)) ; Increased to 4MB for snappier LSP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Package initialization
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;; All subsequent use-package declarations will inherit this
(setopt use-package-always-ensure t)

(use-package auto-package-update
  :defer 10
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setopt inhibit-splash-screen t)
(setopt initial-major-mode 'fundamental-mode)
(setopt display-time-default-load-average nil)
(setq ring-bell-function 'ignore)
(setq initial-scratch-message "")

(add-hook 'minibuffer-exit-hook
          '(lambda ()
             (let ((buffer "*Completions*"))
               (and (get-buffer buffer)
                    (kill-buffer buffer)))))

(setq inhibit-startup-buffer-menu t)
(setq frame-resize-pixelwise t)
(add-hook 'window-setup-hook 'delete-other-windows)
(setq-default line-spacing 0.2)

;; Revert buffers automatically when underlying files change
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

(savehist-mode)
(windmove-default-keybindings)
(setopt sentence-end-double-space nil)

(when (display-graphic-p)
  (context-menu-mode))

;; Backups and lockfiles
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Unicode support
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Editor history limits
(setq undo-limit 80000000)
(setq evil-want-fine-undo t)
(setq scroll-margin 2)
(setq save-interprogram-paste-before-kill t)

;; OS-specific changes
(when (equal system-type 'windows-nt)
  (setq default-directory "C:/Users/kaush/"))

(when (equal system-type 'darwin)
  (setq mac-option-modifier        'meta
        mac-right-option-modifier  'meta
        mac-command-modifier       'control
        package-check-signature    nil
        pixel-scroll-precision-mode nil
        redisplay-dont-pause       t))

(setq delete-by-moving-to-trash t)

;; Flyspell configuration
(cond
 ((equal system-type 'windows-nt)
  (setq ispell-program-name "hunspell")
  (setq ispell-local-dictionary "en_US")
  (setq ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))
  (setenv "DICTIONARY" "en_US")
  (setenv "DICPATH" "C:/Users/kaush/hunspell/")
  (setq ispell-hunspell-dict-paths-alist
        '(("en_US" "C:/Users/kaush/hunspell/en_US.aff"))))

 ((equal system-type 'gnu/linux)
  (when (executable-find "hunspell")
    (setq ispell-program-name "hunspell")
    (setq ispell-really-hunspell t)
    (setq ispell-dictionary "en_US"))))

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(setopt use-short-answers t)
(setq confirm-kill-emacs #'y-or-n-p)
(setq browse-url-browser-function 'eww-browse-url)

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Discovery aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :hook (after-init . which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer/completion settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setopt enable-recursive-minibuffers t)
(setopt completion-cycle-threshold 1)
(setopt completions-detailed t)
(setopt tab-always-indent 'complete)
(setopt completion-styles '(basic initials substring))

(setopt completion-auto-help 'always)
(setopt completions-max-height 20)
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Interface enhancements/defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setopt line-number-mode t)
(setopt column-number-mode t)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(setopt x-underline-at-descent-line nil)
(setopt switch-to-buffer-obey-display-actions t)
(setopt show-trailing-whitespace nil)
(setopt indicate-buffer-boundaries 'left)
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)
(setopt indent-tabs-mode nil)
(setopt tab-width 4)
(blink-cursor-mode 1)

(setopt display-line-numbers-width 3)
(global-display-line-numbers-mode 1)
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                eww-mode-hook
                olivetti-mode-hook
                elfeed-show-mode-hook
                elfeed-search-mode-hook))
  (add-hook mode (lambda ()(display-line-numbers-mode 0))))
(setopt display-line-numbers-type t)

(add-hook 'text-mode-hook 'visual-line-mode)
(dolist (hook '(text-mode-hook prog-mode-hook))
  (add-hook hook 'hl-line-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Misc
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package rainbow-mode
  :commands rainbow-mode)

(use-package rainbow-delimiters
  :commands rainbow-delimiters-mode)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; recent file access
(recentf-mode 1)
(setq recentf-max-saved-items 50)
(global-set-key (kbd "C-c f r") 'consult-recent-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package modus-themes
  :defer t
  :config
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-mixed-fonts t
        modus-themes-variable-pitch-ui nil
        modus-themes-custom-auto-reload t
        modus-themes-disable-other-themes t
        modus-themes-prompts '(italic bold)
        modus-themes-headings
        '((1 . (variable-pitch 1.1))
          (2 . (1.1))
          (agenda-date . (1.1))
          (agenda-structure . (variable-pitch light 1.1))
          (t . (1.1)))))

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))
(load-theme 'modus-operandi :no-confirm)

(winner-mode 1)

(use-package crux
  :defer t
  :bind
  (("C-k" . 'crux-smart-kill-line)
   ("<C-S-return>" . 'crux-smart-open-line-above)
   ("<C-return>" . 'crux-smart-open-line)
   ("C-c P" . 'crux-kill-buffer-truename)
   ("M-o" . 'crux-other-window-or-switch-buffer)))

;; Performance tweaks (emacs-redux)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
(setq redisplay-skip-fontification-on-input t)
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq save-interprogram-paste-before-kill t)
(setq kill-do-not-save-duplicates t)
(setq savehist-additional-variables '(search-ring regexp-search-ring kill-ring))
(setq help-window-select t)
(setq enable-local-variables :safe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Motion aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package avy
  :demand t
  :bind (("C-c j" . avy-goto-line)
         ("C-c k" . avy-goto-char-timer)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Power-ups: Embark and Consult
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s o" . consult-outline)
         ("M-s f" . 'consult-find))
  :config
  (setq consult-narrow-key "<"))

(use-package embark
  :demand t
  :after avy
  :bind (("C-c a" . embark-act))
  :init
  (defun bedrock/avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)
  (setf (alist-get ?. avy-dispatch-alist) 'bedrock/avy-action-embark))

(use-package embark-consult)

(use-package consult-eglot
  :after eglot
  :bind (:map eglot-mode-map
              ("M-g s" . consult-eglot-symbols)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer and completion Packages
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vertico
  :hook (after-init . vertico-mode))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("M-DEL" . vertico-directory-delete-word)))

(use-package marginalia
  :hook (vertico-mode . marginalia-mode))

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.4)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current nil)
  (corfu-preselect 'directory)
  (corfu-on-exact-match 'quit)
  :bind
  (:map corfu-map
        ("<escape>" . 'corfu-quit))
  :config
  (corfu-history-mode))

(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil))

(use-package corfu-terminal
  :if (not (display-graphic-p))
  :config
  (corfu-terminal-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package kind-icon
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package eshell
  :init
  (defun bedrock/setup-eshell ()
    (keymap-set eshell-mode-map "C-r" 'consult-history))
  :hook ((eshell-mode . bedrock/setup-eshell)))

(use-package orderless
  :config
  (setq completion-styles '(orderless)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Misc. editing enhancements
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t))

(use-package surround
  :bind-keymap ("M-'" . surround-keymap))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(cond
 ((equal system-type 'darwin)
  (set-face-attribute 'default nil :family "SF Mono" :weight 'Regular :height 120)
  (set-face-attribute 'variable-pitch nil :family "SF Mono" :weight 'Regular :height 120))
;;  (set-face-attribute 'corfu-default nil :font "SF Mono" :height 120))
 ((equal system-type 'gnu/linux)
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font Mono" :height 110)
  (set-face-attribute 'variable-pitch nil :family "JetBrainsMono Nerd Font Mono" :height 110)
  (set-face-attribute 'corfu-default nil :font "JetBrainsMono Nerd Font Mono" :height 100))
 ((equal system-type 'windows-nt)
  (set-face-attribute 'default nil :family "JetBrains Mono NL" :weight 'Regular :height 100)
  (set-face-attribute 'variable-pitch nil :family "Iosevka Comfy Motion Fixed" :weight 'Regular :height 100)))

(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode 1)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package doom-modeline
  :defer t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 3)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t))

(use-package denote
  :defer 5
  :bind (("C-c n l" . denote-link-or-create)
         ("C-c n n" . denote)))

(cond
 ((equal system-type 'darwin)
  (setq denote-directory (expand-file-name "~/MyDrive/OneDrive/09-Notes")))
 ((equal system-type 'gnu/linux)
  (setq denote-directory (expand-file-name "~/Insync/kaushalbundel@outlook.com/OneDrive/09-Notes/"))))

(setq denote-known-keywords '("work" "personal" "health" "article" "course" "video" "audio"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(denote-rename-buffer-mode 1)

(use-package consult-denote
  :bind
  (("C-c n f" . consult-denote-find)
   ("C-c n g" . consult-denote-grep))
  :config
  (consult-denote-mode 1))

(use-package denote-journal
  :commands ( denote-journal-new-entry
              denote-journal-new-or-existing-entry
              denote-journal-link-or-create-entry )
  :hook (calendar-mode . denote-journal-calendar-mode)
  :bind ("C-c n j" . denote-journal-new-entry)
  :config
  (setq denote-journal-directory (expand-file-name "journal" denote-directory))
  (setq denote-journal-keyword "exerciselog")
  (setq denote-journal-title-format 'day-date-month-year))

(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

(use-package spacious-padding
  :config
  (setq spacious-padding-widths
        '( :internal-border-width 15
           :header-line-width 4
           :mode-line-width 2
           :tab-width 2
           :right-divider-width 24
           :scroll-bar-width 8))
  (spacious-padding-mode 1))

(defun kaushal/copy-buffer-directory-path ()
  "copy buffer directory to clipboard"
  (interactive)
  (kill-new (string-trim-left (pwd) "Directory ")))
(global-set-key (kbd "C-c y d") 'kaushal/copy-buffer-directory-path)

(defun kaushal/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p) (keyboard-quit))
   ((derived-mode-p 'completion-list-mode) (delete-completion-window))
   ((> (minibuffer-depth) 0) (abort-recursive-edit))
   (t (keyboard-quit))))

(define-key global-map (kbd "C-g") #'kaushal/keyboard-quit-dwim)

(use-package org-modern
  :custom
  (org-modern-block-indent t)
  (org-modern-hide-stars nil)
  (org-modern-todo-faces
   '(("STARTED" :foreground "yellow")
     ("Rescheduled" org-special-keyword :inverse-video t :weight bold)))
  (org-modern-label-border 1)
  (modify-all-frames-parameters
   '((right-divider-width . 40)
     (internal-border-width . 40)))
  (dolist (face '(window-divider window-divider-first-pixel window-divider-last-pixel))
    (face-spec-reset-face face)
    (set-face-foreground face (face-attribute 'default :background)))
  (set-face-background 'fringe (face-attribute 'default :background))
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . flyspell-mode)
         (org-mode . org-indent-mode))
  :bind (:map global-map
              ("C-c l s" . org-store-link)
              ("C-c l i" . org-insert-link-global)
              ("C-c x"   . org-capture))
  :config
  (setq org-insert-heading-respect-content t)
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)
  (require 'oc-csl)
  (add-to-list 'org-export-backends 'md)
  (setq org-export-with-smart-quotes t)
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)" "|" "DONE(d!)" "Dropped(o@)" "Rescheduled")))
  (setq org-outline-path-complete-in-steps nil
        org-refile-use-outline-path 'file)
  (setq org-capture-templates
        '(("c" "Default Capture" entry (file "todo.org") "* TODO %?\n%U\n%i")
          ("r" "Capture with Reference" entry (file "todo.org") "* TODO %?\n%U\n%i\n%a")
          ("w" "Work")
          ("wm" "Work meeting" entry (file+headline "work.org" "Meetings") "** TODO %?\n%U\n%i\n%a")
          ("wr" "Work report" entry (file+headline "work.org" "Reports") "** TODO %?\n%U\n%i\n%a")))
  (setopt org-agenda-skip-deadline-if-done t
          org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-custom-commands
        '(("n" "Agenda and All Todos" ((agenda) (todo)))
          ("w" "Work" agenda "" ((org-agenda-files '("work.org"))))
          ("u" "Unscheduled" alltodo "")))
  (add-to-list 'org-modules 'org-habit t)
  (setopt org-log-into-drawer t
          org-habit-following-days 3
          org-habit-preceding-days 7
          org-habit-show-all-today t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Development Environments & Treesitter
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :ensure nil
  :hook ((prog-mode . electric-pair-mode))
  :config
  (setq major-mode-remap-alist
        '((yaml-mode . yaml-ts-mode)
          (bash-mode . bash-ts-mode)
          (javascript-mode . js-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (json-mode . json-ts-mode)
          (css-mode . css-ts-mode)
          (python-mode . python-ts-mode)
          (go-mode . go-ts-mode)
          (rust-mode . rust-ts-mode))))

(use-package swift-mode
  :mode "\\.playground\\'")

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package markdown-mode
  :hook ((markdown-mode . visual-line-mode)))

(use-package yaml-mode)
(use-package json-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Eglot, the built-in LSP client for Emacs
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format))
  :config
  (fset #'jsonrpc--log-event #'ignore)
  (setq eglot-events-buffer-size 0)
  (add-to-list 'eglot-server-programs
               '(python-ts-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(js-ts-mode . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(css-ts-mode . ("vscode-css-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("gopls")))
  (add-to-list 'eglot-server-programs
               '(swift-mode . ("sourcekit-lsp"))))

;; Prefer apheleia for asynchronous, non-blocking auto-formatting
(use-package apheleia
  :defer t
  :config
  (apheleia-global-mode +1))

;; uv-mode keybindings clashing with org mode related keybindings, hence the function
(use-package uv-mode
  :preface
  (defun kaushal/uv-mode-activate-unless-org ()
    "Activate `uv-mode' only if we aren't in an Org source editing buffer."
    (unless (bound-and-true-p org-src-mode)
      (uv-mode-auto-activate-hook)))
  :hook (python-mode . kaushal/uv-mode-activate-unless-org))

(use-package emmet-mode
  :hook ((sgml-mode-hook . emmet-mode)
         (css-mode-hook . emmet-mode)
         (web-mode . emmet-mode)))

(cond
 ((equal system-type 'darwin)
  (use-package highlight-indent-guides
    :hook (prog-mode . highlight-indent-guides-mode)
    :config
    (setopt highlight-indent-guides-method 'character
            highlight-indent-guides-responsive 'top)))
 ((equal system-type 'gnu/linux)
  (use-package indent-bars
    :hook (prog-mode . indent-bars-mode)
    :config
    (setq
     indent-bars-color '(highlight :face-bg t :blend 0.15)
     indent-bars-pattern "."
     indent-bars-width-frac 0.1
     indent-bars-pad-frac 0.1
     indent-bars-zigzag nil
     indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 1)
     indent-bars-highlight-current-depth '(:blend 0.5)
     indent-bars-display-on-blank-lines nil))))
