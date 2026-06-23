;; -*- lexical-binding: t; -*-

(use-package gptel
  :straight t
  :config
  ;; ---- Backend 1: DeepSeek (默认) ----
  (setq gptel-backend
        (gptel-make-openai "DeepSeek"
          :host "api.deepseek.com"
          :key (getenv "DEEPSEEK_API_KEY")
          :stream t
          :models '("deepseek-v4-pro")))

  ;; ---- Backend 2: OpenRouter ----
  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai/api"
    :key (getenv "OPENROUTER_API_KEY")
    :stream t
    :models '("openrouter/free" "openrouter/auto"))

  ;; ---- 全局默认 ----
  (setq gptel-model 'deepseek-v4-pro
        gptel-system-prompt (string-join
                             '("用简体中文回复，除非我有要求。"
                               "可以省略客套，直接给出方案、代码或分析。"
                               "回复尽量精简，不重复问题。")
                            " ")))

(global-set-key (kbd "C-c x") 'gptel-menu)

;; 安装gptel-agent
(use-package gptel-agent
  :straight t
  :after gptel)

(global-set-key (kbd "C-c p") 'gptel-agent)

(provide 'init-llm)
 
