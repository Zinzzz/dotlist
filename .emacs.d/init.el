(require 'mozc)
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;;color-theme
(load-theme 'misterioso t)

; $B%m!<%I%Q%9$NDI2C(B
(setq load-path (append
                 '("~/.emacs.d"
                   "~/.emacs.d/packages")
                 load-path))

;; C-z $B$r(B undo 
(define-key global-map (kbd "C-z") 'undo)
;; C-t $B$G(B suspend-frame
(define-key global-map (kbd "C-t") 'suspend-frame)
;; C-k $B$G(B kill-whole-line 
(define-key global-map (kbd "C-k") 'kill-whole-line)
;; $B9T%3%T!<4X?t(B
(defun copy-whole-line (&optional arg)
  "Copy current line."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (unless (eq last-command 'copy-region-as-kill)
    (kill-new "")
    (setq last-command 'copy-region-as-kill))
  (cond ((zerop arg)
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))))
        ((< arg 0)
         (save-excursion
           (copy-region-as-kill (point) (progn (end-of-visible-line) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line (1+ arg))
                                       (unless (bobp) (backward-char))
                                       (point)))))
        (t
         (save-excursion
           (copy-region-as-kill (point) (progn (forward-visible-line 0) (point)))
           (copy-region-as-kill (point)
                                (progn (forward-visible-line arg) (point))))))
  (message (substring (car kill-ring-yank-pointer) 0 -1)))
;; C-d $B$G(B copy-whole-line
(define-key global-map (kbd "C-d") 'copy-whole-line)

;; $B%9%?!<%H%"%C%W%a%C%;!<%8$rI=<($5$;$J$$(B
(setq inhibit-startup-message t)

;; xterm $B$N%^%&%9%$%Y%s%H$r<hF@$9$k(B
(xterm-mouse-mode t)
(global-set-key   [mouse-4] '(lambda () (interactive) (scroll-down 1)))
(global-set-key   [mouse-5] '(lambda () (interactive) (scroll-up   1)))

; $B=*N;;~$K%*!<%H%;!<%V%U%!%$%k$r:o=|$9$k(B
(setq delete-auto-save-files t)

; $B%?%V$K%9%Z!<%9$r;HMQ$9$k(B
(setq-default tab-width 2 indent-tabs-mode nil) 

;;$B3HD%;R$G%b!<%I;XDj(B
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

; $BNs?t$rI=<($9$k(B
(column-number-mode t)

; $B9T?t$rI=<($9$k(B
(global-linum-mode t)

; $B%+!<%=%k9T$r%O%$%i%$%H$9$k(B
(global-hl-line-mode t)

; $BBP1~$9$k3g8L$r8w$i$;$k(B
(show-paren-mode 1)

; $B%9%/%m!<%k$O#19T$4$H$K(B
(setq scroll-conservatively 1)

; $B%7%U%H!\Lp0u$GHO0OA*Br(B
(setq pc-select-selection-keys-only t)

;package system
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;smartparens
(require 'smartparens-config)
(smartparens-global-mode t)

;yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;auto-java-complete
(add-to-list 'load-path "~/.emacs.d/auto-java-complete")
(require 'ajc-java-complete-config)
(add-hook 'java-mode-hook 'ajc-java-complete-mode)

;jedi
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


; Auto Complete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-mode$B$G$b<+F0E*$KM-8z$K$9$k(B
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; $BJd40%a%K%e!<I=<(;~$K(BC-n/C-p$B$GJd408uJdA*Br(B
(setq ac-use-fuzzy t)          ;; $B[#Kf%^%C%A(B

;; SBCL$B$r%G%U%)%k%H$N(BCommon Lisp$B=hM}7O$K@_Dj(B
(setq inferior-lisp-program "sbcl")
;; SLIME$B$N%m!<%I(B
(require 'slime)
(slime-setup '(slime-repl slime-fancy slime-banner)) 
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
 ;; SLIME$B=*N;$N$?$a$N4X?t(B
(defun slime-smart-quit ()
  (interactive)
  (when (slime-connected-p)
    (if (equal (slime-machine-instance) "my.workstation")
      (slime-quit-lisp)
      (slime-disconnect)))
  (slime-kill-all-buffers))
; Emacs$B=*N;;~$K<+F0E*$K8F$S=P$7(B
(add-hook 'kill-emacs-hook 'slime-smart-quit)

