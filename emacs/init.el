;;; Manage/control package systems
(require 'package)
(package-initialize)
(setq package-archives
  '(("gnu" . "http://elpa.gnu.org/packages/")
    ("melpa" . "http://melpa.org/packages/")
    ("org" . "http://orgmode.org/elpa/")))

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
    t
    (if (or (assoc package package-archive-contents) no-refresh)
      (if (boundp 'package-selected-packages)
        ;; Record this as a package the user installed explicitly
        (package-install package nil)
        (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
  In the event of failure, return nil and print a warning message.
  Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
  available package lists will not be re-downloaded in order to
  locate PACKAGE."
  (condition-case err
    (require-package package min-version no-refresh)
    (error
      (message "Couldn't install optional package `%s': %S" package err)
      nil)))

;;; Add path for customized config .el files
;; (add-to-list 'load-path "~/.emacs.d/site-lisp")
(add-to-list 'load-path "~/.emacs.d/lisp/")

;;; Disable warnings
(setq warning-minimum-level :warning)

;;; Train white spaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq whitespace-space-regexp "\\(\u3000+\\)")
(setq whitespace-action '(auto-cleanup))
;; (global-whitespace-mode 1)

;;; Customize variables/faces
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cython-mode markdown-mode yaml-mode magit-lfs dockerfile-mode web-mode py-autopep8 markdown-preview-mode magit jedi autopair auto-complete-auctex auctex anything)))
 '(safe-local-variable-values (quote ((code . utf-8))))
 '(send-mail-function (quote mailclient-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-header-delimiter-face ((t (:inherit org-mode-line-clock))))
 '(markdown-pre-face ((t (:inherit org-formula))))
 '(show-paren-match ((((class color) (background light)) (:background "#b03060")))))

;;; Set encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;;; Disable/Enable backup
(setq make-backup-files nil)
;; (setq backup-directory-alist `(("." . "~/.emacs.d/.backup")))
;;; Disable/Enable auto save
(setq auto-save-default nil)
;; (setq auto-save-file-name-transforms
;;   `((".*" "~/.emacs.d/.auto-save" t)))
;;; Store backup/auto-saved files in /tmp
(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))
;;; Show line number
(line-number-mode t)
;; (require 'linum)
;; (global-linum-mode 1)
;; (setq linum-format "%4d ")
;;; Show column number
(column-number-mode t)
;;; Scroll one line at a time
(setq scroll-conservatively 1)
;;; Show file size
(size-indication-mode t)
;;; Show date and time
(setq display-time-24hr-format t)
(display-time-mode t)

;;; Show pairs (), {}, []
(show-paren-mode t)
;; (show-paren-mode 1)
(setq show-paren-style 'parenthesis)
(setq show-paren-delay 0)
(setq show-paren-style 'single)

;;; Enable auto-completion
(add-to-list 'load-path "~/.emacs.d/site-lisp/anything-config/")

(require 'anything)
;; (require 'anything-config)
(require 'anything-match-plugin)
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;; Set default spell checker
(setq-default ispell-program-name "aspell")

;;; C
;; Set default C indentation
(setq c-default-style "linux" c-basic-offset 4)

;;; Python
;; Set default Python indentation
;; python-mode
; (setq-default c-basic-offset 4)
(setq-default python-indent-guess-indent-offset nil)
(autoload 'python-mode "python-mode" "Python Mode" t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; Use IPython as the default Python shell
;; (setq ipython-command ".pyenv/shims/ipython")
;; (require 'ipython)
;; (setq python-shell-interpreter "ipython"
;;   python-shell-interpreter-args "-i")
;; jedi
(require 'epc)
(require 'python)
;; (setenv "PYTHONPATH" "/Users/msato/.pyenv/versions/py36/lib/python3.6/site-packages")
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
; (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
; (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
; (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)
;; auto-pep8
(require 'py-autopep8)
(setq py-autopep8-options '("--max-line-length=79"))
;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;; autopair
(autoload 'autopair-global-mode "autopair" nil t)
(autopair-global-mode)
(add-hook 'python-mode-hook
  #'(lambda ()
      (push '(?' . ?')
        (getf autopair-extra-pairs :code))
      (setq autopair-handle-action-fns
        (list #'autopair-default-handle-action
        #'autopair-python-triple-quote-action))))

;;; JavaScript
(defun js-mode-hook ()
  "Hooks for js mode."
  (setq indent-tabs-mode nil))
(add-hook 'js-mode-hook 'js-mode-hook)

;;; Web
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-html-offset 2)
  (setq web-mode-css-offset 2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset 2)
  (setq web-mode-java-offset 2)
  (setq web-mode-asp-offset 2)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-extra-auto-pairs
      '(("erb"  . (("beg" "end")))
        ("php"  . (("beg" "end")
                   ("beg" "end")))
       ))
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-ac-sources-alist
       '(("css" . (ac-source-css-property))
              ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;;; PHP
(autoload 'php-mode "php-mode" "Major mode for editing PHP code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;; Set default PHP indentation
(defun php-indent-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  ;; (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0))
(add-hook 'php-mode-hook 'php-indent-hook)
;; Auto-complete for PHP
(defun php-completion-hook ()
  (when (require 'php-completion nil t)
   (php-completion-mode t)
   (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
   (when (require 'auto-complete nil t)
     (make-variable-buffer-local 'ac-sources)
     (add-to-list 'ac-sources 'ac-source-php-completion)
     (auto-complete-mode t))))
(add-hook 'php-mode-hook 'php-completion-hook)

;;; Markdown
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;; Git
;; (require 'magit)
;; (setq magit-view-git-manual-method 'man)

;;; Docker
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;;; YAML
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))
(define-key yaml-mode-map "\C-m" 'newline-and-indent)

;;; AUCTeX
;; Auto-complete for AUCTeX
(require 'auto-complete-auctex)
;; Linux
(when (eq system-type 'gnu/linux)
  (with-eval-after-load 'tex
    (defun TeX-evince-sync-view ()
      (require 'url-util)
      (let* ((uri (concat "file://" (url-encode-url
                                     (expand-file-name
                                      (concat file "." "pdf")))))
             (owner (dbus-call-method
                     :session "org.gnome.evince.Daemon"
                     "/org/gnome/evince/Daemon"
                     "org.gnome.evince.Daemon"
                     "FindDocument"
                     uri
                     t)))
        (if owner
            (with-current-buffer (or (when TeX-current-process-region-p
                                       (get-file-buffer (TeX-region-file t)))
                                     (current-buffer))
              (sleep-for 0.2)
              (dbus-call-method
               :session owner
               "/org/gnome/evince/Window/0"
               "org.gnome.evince.Window"
               "SyncView"
               (buffer-file-name)
               (list :struct :int32 (line-number-at-pos) :int32 (1+ (current-column)))
               :uint32 0))
          (error "Couldn't find the Evince instance for %s" uri)))))
  (with-eval-after-load 'tex-jp
    (setq TeX-engine-alist '((pdfuptex "pdfupTeX"
                                       "ptex2pdf -u -e -ot '%S %(mode)'"
                                       "ptex2pdf -u -l -ot '%S %(mode)'"
                                       "euptex")))
    (setq japanese-TeX-engine-default 'pdfuptex)
                                        ;(setq japanese-TeX-engine-default 'luatex)
                                        ;(setq japanese-TeX-engine-default 'xetex)
    (setq TeX-view-program-selection '((output-dvi "Evince")
                                       (output-pdf "Evince")))
                                        ;(setq TeX-view-program-selection '((output-dvi "Okular")
                                        ;                                   (output-pdf "Okular")))
    (setq japanese-LaTeX-default-style "bxjsarticle")
                                        ;(setq japanese-LaTeX-default-style "ltjsarticle")
    (dolist (command '("pTeX" "pLaTeX" "pBibTeX" "jTeX" "jLaTeX" "jBibTeX" "Mendex"))
      (delq (assoc command TeX-command-list) TeX-command-list)))
  (setq preview-image-type 'dvipng)
  (setq TeX-source-correlate-method 'synctex)
  (setq TeX-source-correlate-start-server t)
  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook
            (function (lambda ()
                        (add-to-list 'TeX-command-list
                                     '("Latexmk"
                                       "latexmk %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-upLaTeX-pdfdvi"
                                       "latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfdvi"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-upLaTeX-pdfps"
                                       "latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvips=q/dvips %%O -z -f %%S | convbkmk -u > %%D/' -e '$ps2pdf=q/ps2pdf %%O %%S %%D/' -norc -gg -pdfps %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfps"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-pdfLaTeX"
                                       "latexmk -e '$pdflatex=q/pdflatex %%O %S %(mode) %%S/' -e '$bibtex=q/bibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/makeindex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-pdfLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-LuaLaTeX"
                                       "latexmk -e '$pdflatex=q/lualatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-LuaJITLaTeX"
                                       "latexmk -e '$pdflatex=q/luajitlatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaJITLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-XeLaTeX"
                                       "latexmk -e '$pdflatex=q/xelatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-XeLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("xdg-open"
                                       "xdg-open %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run xdg-open"))
                        (add-to-list 'TeX-command-list
                                     '("Evince"
                                        ;"synctex view -i \"%n:0:%b\" -o %s.pdf -x \"evince -i %%{page+1} %%{output}\""
                                       "TeX-evince-sync-view"
                                       TeX-run-discard-or-function t t :help "Forward search with Evince"))
                        (add-to-list 'TeX-command-list
                                     '("fwdevince"
                                       "fwdevince %s.pdf %n \"%b\""
                                       TeX-run-discard-or-function t t :help "Forward search with Evince"))
                        (add-to-list 'TeX-command-list
                                     '("Okular"
                                       "okular --unique \"file:\"%s.pdf\"#src:%n %a\""
                                       TeX-run-discard-or-function t t :help "Forward search with Okular"))
                        (add-to-list 'TeX-command-list
                                     '("zathura"
                                       "zathura -x \"emacsclient --no-wait +%%{line} %%{input}\" --synctex-forward \"%n:0:%b\" %s.pdf"
                                       TeX-run-discard-or-function t t :help "Forward search with zathura"))
                        (add-to-list 'TeX-command-list
                                     '("qpdfview"
                                       "qpdfview --unique \"\"%s.pdf\"#src:%b:%n:0\""
                                       TeX-run-discard-or-function t t :help "Forward search with qpdfview"))
                        (add-to-list 'TeX-command-list
                                     '("TeXworks"
                                       "synctex view -i \"%n:0:%b\" -o %s.pdf -x \"texworks --position=%%{page+1} %%{output}\""
                                       TeX-run-discard-or-function t t :help "Run TeXworks"))
                        (add-to-list 'TeX-command-list
                                     '("TeXstudio"
                                       "synctex view -i \"%n:0:%b\" -o %s.pdf -x \"texstudio --pdf-viewer-only --page %%{page+1} %%{output}\""
                                       TeX-run-discard-or-function t t :help "Run TeXstudio"))
                        (add-to-list 'TeX-command-list
                                     '("MuPDF"
                                       "mupdf %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run MuPDF"))
                        (add-to-list 'TeX-command-list
                                     '("Firefox"
                                       "firefox -new-window %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Mozilla Firefox"))
                        (add-to-list 'TeX-command-list
                                     '("Chromium"
                                       "chromium --new-window %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Chromium"))))))

;; macOS
(when (eq system-type 'darwin)
  (setenv "PATH"
          (concat (getenv "PATH") ":/Library/TeX/texbin"))
  (with-eval-after-load 'tex-jp
    (setq TeX-engine-alist '((pdfuptex "pdfupTeX"
                                       "/Library/TeX/texbin/ptex2pdf -u -e -ot '%S %(mode)'"
                                       "/Library/TeX/texbin/ptex2pdf -u -l -ot '%S %(mode)'"
                                       "euptex")))
    (setq japanese-TeX-engine-default 'pdfuptex)
                                        ;(setq japanese-TeX-engine-default 'luatex)
                                        ;(setq japanese-TeX-engine-default 'xetex)
    (setq TeX-view-program-selection '((output-dvi "displayline")
                                       (output-pdf "displayline")))
                                        ;(setq TeX-view-program-selection '((output-dvi "Skim")
                                        ;                                   (output-pdf "Skim")))
    (setq japanese-LaTeX-default-style "bxjsarticle")
                                        ;(setq japanese-LaTeX-default-style "ltjsarticle")
    (dolist (command '("pTeX" "pLaTeX" "pBibTeX" "jTeX" "jLaTeX" "jBibTeX" "Mendex"))
      (delq (assoc command TeX-command-list) TeX-command-list)))
  (setq preview-image-type 'dvipng)
  (setq TeX-source-correlate-method 'synctex)
  (setq TeX-source-correlate-start-server t)
  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook
            (function (lambda ()
                        (add-to-list 'TeX-command-list
                                     '("Latexmk"
                                       "/Library/TeX/texbin/latexmk %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-upLaTeX-pdfdvi"
                                       "/Library/TeX/texbin/latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvipdf=q/dvipdfmx %%O -o %%D %%S/' -norc -gg -pdfdvi %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfdvi"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-upLaTeX-pdfps"
                                       "/Library/TeX/texbin/latexmk -e '$latex=q/uplatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -e '$dvips=q/dvips %%O -z -f %%S | convbkmk -u > %%D/' -e '$ps2pdf=q/ps2pdf %%O %%S %%D/' -norc -gg -pdfps %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-upLaTeX-pdfps"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-pdfLaTeX"
                                       "/Library/TeX/texbin/latexmk -e '$pdflatex=q/pdflatex %%O %S %(mode) %%S/' -e '$bibtex=q/bibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/makeindex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-pdfLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-LuaLaTeX"
                                       "/Library/TeX/texbin/latexmk -e '$pdflatex=q/lualatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-LuaJITLaTeX"
                                       "/Library/TeX/texbin/latexmk -e '$pdflatex=q/luajitlatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-LuaJITLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("Latexmk-XeLaTeX"
                                       "/Library/TeX/texbin/latexmk -e '$pdflatex=q/xelatex %%O %S %(mode) %%S/' -e '$bibtex=q/upbibtex %%O %%B/' -e '$biber=q/biber %%O --bblencoding=utf8 -u -U --output_safechars %%B/' -e '$makeindex=q/upmendex %%O -o %%D %%S/' -norc -gg -pdf %t"
                                       TeX-run-TeX nil (latex-mode) :help "Run Latexmk-XeLaTeX"))
                        (add-to-list 'TeX-command-list
                                     '("displayline"
                                       "/Applications/Skim.app/Contents/SharedSupport/displayline %n %s.pdf \"%b\""
                                       TeX-run-discard-or-function t t :help "Forward search with Skim"))
                        (add-to-list 'TeX-command-list
                                     '("Skim"
                                       "/usr/bin/open -a Skim.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Skim"))
                        (add-to-list 'TeX-command-list
                                     '("Preview"
                                       "/usr/bin/open -a Preview.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Preview"))
                        (add-to-list 'TeX-command-list
                                     '("TeXShop"
                                       "/usr/bin/open -a TeXShop.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run TeXShop"))
                        (add-to-list 'TeX-command-list
                                     '("TeXworks"
                                       "/Library/TeX/texbin/synctex view -i \"%n:0:%b\" -o %s.pdf -x \"/Applications/TeXworks.app/Contents/MacOS/TeXworks --position=%%{page+1} %%{output}\""
                                       TeX-run-discard-or-function t t :help "Run TeXworks"))
                        (add-to-list 'TeX-command-list
                                     '("TeXstudio"
                                       "/Library/TeX/texbin/synctex view -i \"%n:0:%b\" -o %s.pdf -x \"/Applications/texstudio.app/Contents/MacOS/texstudio --pdf-viewer-only --page %%{page+1} %%{output}\""
                                       TeX-run-discard-or-function t t :help "Run TeXstudio"))
                        (add-to-list 'TeX-command-list
                                     '("Firefox"
                                       "/usr/bin/open -a Firefox.app %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Mozilla Firefox"))
                        (add-to-list 'TeX-command-list
                                     '("acroread"
                                       "/usr/bin/open -a \"Adobe Acrobat Reader DC.app\" %s.pdf"
                                       TeX-run-discard-or-function t t :help "Run Adobe Acrobat Reader DC"))))))
;; RefTeX with AUCTeX
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
;; kinsoku.el
(setq kinsoku-limit 10)

;;;IPython Notebook
;; (require 'ein)
;; (require 'ein-loaddefs)
;; (require 'ein-notebook)
;; (require 'ein-subpackages)
;; (add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
