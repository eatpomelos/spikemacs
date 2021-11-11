;; ���ļ���ivy�������֮��Ż����
;; ���������ֱ��������Ż�modeline�Լ�����ivy���ui��ͼ����ʾ 
;; (straight-use-package 'doom-modeline)
(straight-use-package 'all-the-icons-ivy-rich)
(straight-use-package 'all-the-icons-dired)
(straight-use-package 'all-the-icons-ibuffer)
(straight-use-package 'all-the-icons-completion)

;; (doom-modeline-mode 1)
(all-the-icons-ivy-rich-mode t)
;; ���Կ��ǰ�ibuffer����Ҳ������
(all-the-icons-ibuffer-mode 1)
(all-the-icons-completion-mode)

;; ��dired��ui֧��
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

;; ����title-format
(defvar spk-title-format (concat "Emacs@Spikemacs" "== " "��(��ա�*��)�� "))
(setq-default frame-title-format spk-title-format)

(provide 'init-ui)
