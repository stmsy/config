;;; Manage/control package systems
(setq package-check-signature nil)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(setq package-archives
  '(("gnu" . "https://elpa.gnu.org/packages/")
    ("melpa" . "https://melpa.org/packages/")
    ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

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

;;; Enable to update the GPG keys
(require-package 'gnu-elpa-keyring-update)
(gnu-elpa-keyring-update)

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
    (cython-mode markdown-mode yaml-mode magit-lfs dockerfile-mode web-mode py-autopep8 markdown-preview-mode magit jedi autopair anything)))
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
(require-package 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;; Enable autopair
(require-package 'autopair)

;;; Set default spell checker
(setq-default ispell-program-name "aspell")

;;; C
;; Set default C indentation
(setq c-default-style "linux" c-basic-offset 4)

;;; Python
;; Set default Python indentation
;; python-mode
(require-package 'python-mode)
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
(require-package 'epc)
(require-package 'python)
;; (setenv "PYTHONPATH" "~/.pyenv/versions/py36/lib/python3.6/site-packages")
(require-package 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
; (define-key python-mode-map "\C-ct" 'jedi:goto-definition)
; (define-key python-mode-map "\C-cb" 'jedi:goto-definition-pop-marker)
; (define-key python-mode-map "\C-cr" 'helm-jedi-related-names)
;; auto-pep8
(require-package 'py-autopep8)
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
(require-package 'web-mode)
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
;; (require-package 'magit)
;; (setq magit-view-git-manual-method 'man)

;;; Docker
(require-package 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;;; YAML
(require-package 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))

(put 'set-goal-column 'disabled nil)
(put 'upcase-region 'disabled nil)
