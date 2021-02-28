;;; ~/.doom.d/local/packages/my-insert-index.el -*- lexical-binding: t; -*-

;; 在编写org 文件之后运行函数能够自动生成前面的索引，方便后面的跳转
;; 如果没有输入文件就直接将当前文件当做是参数，编写两个函数，一个是在指定文件中插入，一个函数用来调用这个函数
(defun my-insert-index (file)
  "Insert a index in org file.Insert index in line N.
If line is nil insert in after title line."
  (interactive)
  (buffer-size)
  (let* (())))


(count-lines (point-min) (point-max))

(insert "hello world\n and you")

(defun -region-or-word ()
  "Return word in region or word at point."
  (if (derived-mode-p 'pdf-view-mode)
      (if (pdf-view-active-region-p)
          (mapconcat 'identity (pdf-view-active-region-text) "\n"))
    (if (use-region-p)
        (buffer-substring-no-properties (region-beginning)
                                        (region-end))
      (thing-at-point (if use-chinese-word-segmentation
                          'chinese-or-other-word
                        'word)
                      t))))

;; 定义自己的脚本存放路径，用来自己平时编写一些简单的脚本
