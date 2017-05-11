(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

; ADD TO THE LOAD-PATH

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; Add MELPA repo

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))

 ;; Customization

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tool-bar-mode nil)
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (whiteboard)))
 '(org-agenda-files nil)
)

; Enable visual mode everywhere
(global-visual-line-mode 1)

;;; Aliases

(defalias 'snippet 'yas-insert.snippet)
(defalias 'ts 'transpose-sentences)
(defalias 'tp 'transpose-paragraphs)
(defalias 'wrt 'writeroom-mode)

;;;;;;;;;;;;; MODES ;;;;;;;;;;;

;;; YASNIPPET MODE ;;;

(add-to-list 'load-path
              "~/.emacs.d/lisp/yasnippet")
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        "~/.emacs.d/lisp/yasnippet/snippets"         ;; the default collection
        ))

(yas-global-mode 1)

;(yas-reload-all)
;(add-hook 'prog-mode-hook #'yas-minor-mode)

;;; ORG MODE ;;;

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

   ;; The following lines are always needed.  Choose your own keys.
     (global-set-key "\C-cl" 'org-store-link)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-cc" 'org-capture)
     (global-set-key "\C-cb" 'org-iswitchb)

; Hide emphasis markers
(setq org-hide-emphasis-markers t)

; org-bullets -> better headers
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

; Org-Mobile

(setq org-mobile-directory "~/Dropbox/notes/org")

;;; Proselint ;;;

(require 'flycheck)
(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
	    (id (one-or-more (not (any " "))))
	    (message (one-or-more not-newline)
                     (zero-or-more "\n" (any " ") (one-or-more not-newline)))
            line-end))
  :modes (text-mode markdown-mode gfm-mode org-mode))

(add-to-list 'flycheck-checkers 'proselint)

 ;; Define a function to make it faster

(defun proselint ()
  (interactive)
  (flycheck-mode)
  (flycheck-select-checker 'proselint)
  (flycheck-list-errors))

;;; AUCTEX ;;;;

;(load "auctex.el" nil t t)
; enable document parsing
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-PDF-mode t)
; use a better algo fo identify the master file
(setq-default TeX-master nil)
; assume that main files are master files
;(setq-default TeX-master "../main.tex")
; enable folding
(add-hook 'TeX-mode-hook (lambda ()
                             (TeX-fold-mode 1)))
; so that it can find the Tex binaries
;(setenv "PATH" (concat (getenv "PATH") ":/usr/texbin"))
;(setq exec-path (append exec-path '("/usr/texbin")))

; Spell-check using flyspell with the lang set in babel
(autoload 'flyspell-babel-setup "flyspell-babel")
(add-hook 'latex-mode-hook 'flyspell-babel-setup)


;;; COUNT WORDS MODE ;;;;

(setq load-path (cons (expand-file-name "~/emacs.d/lisp") load-path))
(autoload 'word-count-mode "word-count"
          "Minor mode to count words." t nil)
(global-set-key "\M-+" 'word-count-mode)

(word-count-mode 1)


;;; web-mode ;;;

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;; prettify ALL the things ;;;

(require 'pretty-mode)
(global-pretty-mode nil)

(pretty-deactivate-groups
 '(:equality :ordering :ordering-double :ordering-triple
             :arrows :arrows-twoheaded :punctuation
             :logic :sets))

(pretty-activate-groups
 '(:sub-and-superscripts :greek :arithmetic-nary))

(global-prettify-symbols-mode 1)

(global-prettify-symbols-mode 1)

(add-hook
 'latex-mode-hook
 (lambda ()
   (mapc (lambda (pair) (push pair prettify-symbols-alist))
         '(;; Syntax
           ("def" .      #x2131)
           ("not" .      #x2757)
           ("in" .       #x2208)
           ("not in" .   #x2209)
           ("return" .   #x27fc)
           ("yield" .    #x27fb)
           ("for" .      #x2200)
           ;; Base Types
           ("int" .      #x2124)
           ("float" .    #x211d)
           ("str" .      #x1d54a)
           ("True" .     #x1d54b)
           ("False" .    #x1d53d)
           ;; Mypy
           ("Dict" .     #x1d507)
           ("List" .     #x2112)
           ("Tuple" .    #x2a02)
           ("Set" .      #x2126)
           ("Iterable" . #x1d50a)
           ("Any" .      #x2754)
           ("Union" .    #x22c3)))))


;;; python modes ;;

;;; Use python 3
(setq py-python-command "python3")

;;; Use IPython with python mode ;;;


;; ; use IPython
;; (setq-default py-shell-name "ipython")
;; (setq-default py-which-bufname "IPython")
;; ; use the wx backend, for both mayavi and matplotlib
;; (setq py-python-command-args
;;   '("--gui=wx" "--pylab=wx" "-colors" "Linux"))
;; (setq py-force-py-shell-name-p t)

;; ; switch to the interpreter after executing code
;; (setq py-shell-switch-buffers-on-execute-p t)
;; (setq py-switch-buffers-on-execute-p t)
;; ; don't split windows
;; (setq py-split-windows-on-execute-p nil)
;; ; try to automagically figure out indentation
;; (setq py-smart-indentation t)

;; ; something
;; (setq python-shell-interpreter "ipython")
;; (setq python-shell-interpreter-args "--pylab")
