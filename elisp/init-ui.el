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


(provide 'init-ui)
