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

; ロードパスの追加
(setq load-path (append
                 '("~/.emacs.d"
                   "~/.emacs.d/packages")
                 load-path))

;; C-z を undo 
(define-key global-map (kbd "C-z") 'undo)
;; C-t で suspend-frame
(define-key global-map (kbd "C-t") 'suspend-frame)
;; C-k で kill-whole-line 
(define-key global-map (kbd "C-k") 'kill-whole-line)
;; 行コピー関数
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
;; C-d で copy-whole-line
(define-key global-map (kbd "C-d") 'copy-whole-line)

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message t)

;; xterm のマウスイベントを取得する
(xterm-mouse-mode t)
(global-set-key   [mouse-4] '(lambda () (interactive) (scroll-down 1)))
(global-set-key   [mouse-5] '(lambda () (interactive) (scroll-up   1)))

; 終了時にオートセーブファイルを削除する
(setq delete-auto-save-files t)

; タブにスペースを使用する
(setq-default tab-width 2 indent-tabs-mode nil) 

;;拡張子でモード指定
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))

; 列数を表示する
(column-number-mode t)

; 行数を表示する
(global-linum-mode t)

; カーソル行をハイライトする
(global-hl-line-mode t)

; 対応する括弧を光らせる
(show-paren-mode 1)

; スクロールは１行ごとに
(setq scroll-conservatively 1)

; シフト＋矢印で範囲選択
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
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)          ;; 曖昧マッチ

;; SBCLをデフォルトのCommon Lisp処理系に設定
(setq inferior-lisp-program "sbcl")
;; SLIMEのロード
(require 'slime)
(slime-setup '(slime-repl slime-fancy slime-banner)) 
(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
 ;; SLIME終了のための関数
(defun slime-smart-quit ()
  (interactive)
  (when (slime-connected-p)
    (if (equal (slime-machine-instance) "my.workstation")
      (slime-quit-lisp)
      (slime-disconnect)))
  (slime-kill-all-buffers))
; Emacs終了時に自動的に呼び出し
(add-hook 'kill-emacs-hook 'slime-smart-quit)

