# vjump Agent 工程约束

本文件是法律层：约束 AI Agent 在本目录（vjump/）中的修改行为——怎么修改、怎么诊断、怎么验证。
认知导航（vundo 参考架构、设计数据流）见 ~/spk-docs/Code/elisp/vundo/SKILL.md；想法来源见 denote 笔记 20260707T094248。
本文件不复制上述内容，只规定行为边界。

## 写入分区与候选晋升

- AI 可写：vjump.el、vjump-test.el、check.sh
- AI 只读：AGENTS.md（本文件）
- 晋升流程：AI 产出 → ./check.sh 全绿 → 用户逐行审 diff → 用户明确接受后成为生产代码
- 本目录无版本控制，回退 = 用户改前自行备份。AI 不得以"顺手备份"名义把文件复制出目录

## 唯一职责

本包拥有：跳转历史的采集（advice `vjump-functions` 清单中的命令）、线性 append-only 日志、
back/forward/list 导航、探索树渲染与预览导航（vundo 式横向布局，渲染期从日志派生）、手动标记（vjump-mark）。
它不拥有：位置模糊恢复（context-snippet 匹配，二期）、
任何 LSP/xref 语义（只采集位置，不理解符号）。
最小支持形态：vjump.el 运行时零依赖（emacs -Q 可加载）；断言独立在 vjump-test.el。

## 工程纪律（反例驱动）

- 存储层是线性 append-only 日志，newest-first。
  ✗ 给 vjump--log 引入 parent/children 树结构 → 树是渲染期派生态，进存储层即越界
  ✗ 缓存派生树到全局或日志 → 渲染即派生，日志是唯一真相
- 一次修改必须创造净值：simplicity / robustness / code size / test quality 至少一项。
  ✗ 移动代码、加 wrapper、复制校验不算净值
- 修改前先跑 ./check.sh 确认绿色基线；修改后红即回退，不在红基线上叠改动

## 语言与编码

公开符号 `vjump-` 前缀，内部 `vjump--` 前缀；lexical-binding: t；注释中文，docstring 英文。
API 声明下限 Emacs 28.1，实际以本机 Emacs 为准（check.sh 的 --batch -Q 即零依赖证明）。
advice 允许加在未定义符号上（惰性加载命令定义后自动生效）——这是采集层依赖的既证行为，
更换采集机制前须重新验证。

## 状态契约

全局状态只有 `vjump--log` / `vjump--cur` / `vjump--pending` 三项；
`vjump--t-*` 是 vjump-self-test 专用变量，包运行时不读写。
hook 只允许两处：vjump-mode 装拆 advice；异步采集的 post-command-hook 挂载
（入账或取消即摘除）。除此之外禁止新增全局副作用。

## 诊断纪律

先命名故障层再改行为，逐层排查：
1. 采集层：advice 是否触发（vjump-mode 开启、函数在 vjump-functions 清单内）
2. 时序层：异步跳转（lsp-bridge）落位是否早于下一次命令采样
3. 位置层：marker 死活（buffer 关闭）、file+point 回退是否漂移
4. 导航层：vjump--cur 边界（0 与 length-1）
5. 派生层：vjump--tree 的 origin/destination 配对与位置合并
6. 显示层：vjump-list 横向网格渲染与预览导航

同一问题两次修复失败 → 停止打补丁，回诊断层重新定位，并在报告中说明。

## 领域不变量

- 日志只增不删；唯一删除 = 超过 vjump-limit 时从最旧端截断
- back 使 cur 增大（更旧），forward 使 cur 减小（更新）；当前位置恒等于 log[cur]
- 出发位置与当前记录精确同点（未移动）才跳过 origin；移动过（哪怕几行）即双记录
  [origin, destination]——back 先回出发位置，树在当前节点下开新枝
- 同步跳转零位移才不算跳（跳了即事实，去重职责在树派生）；
  异步采样在同 buffer 位移 < vjump-position-delta 时视为仍在等落位（防漂移噪声）
- 打开 vjump-list 先结清挂起的异步跳转（原窗口此刻位置即落位），
  防止 RET 导航的 cancel-pending 丢弃真实跳转
- 忽略清单 vjump-ignored-buffers：buffer 名匹配任一正则即不入账——跳转的出发端或
  到达端任一命中则整次不入账，mark 命中不记录；默认含 vjump 自有 buffer
- 无文件 buffer 的记录依赖 marker 存活；marker 死且无 file 的记录视为失效
- 树派生规则：destination 的父节点 = 其时间前驱记录；重访（origin 与 destination
  同规则）精确同位才合并，移动过的 origin 立新节点挂 anchor 章；
  回到祖先的边折叠不渲染（防环路）。origin-p 记录推送角色，anchor 盖章出发瞬间的
  当前记录（log[cur]——vjump-list RET / back / forward 置位）；
  新节点（跳转 origin 与 vjump-mark 同规则）一律挂最后访问节点下：
  该节点是叶子即延链，非叶即分岔；两者皆是日志的原始事实
- x 跟随 list 光标节点；RET 把 cur 提交到选中节点；C-g/q 恢复打开列表前的窗口位置；
  光标与 x 按 sel-rec 定位，sel-rec 被重访合并时按同位匹配兜底（不落末行）
- 结构证明 ≠ 运行正确：check.sh 全绿不覆盖 vjump-list 显示与真机 lsp-bridge 时序，
  这两项属活体验证

## 测试与验证

确定性门禁 = ./check.sh（双文件 byte-compile 零 warning + vjump-test.el 内的 vjump-self-test），exit code 裁决。
断言写行为契约（见「领域不变量」），不写实现细节。断言不依赖 GUI / 网络 / LSP。

## 生成期修改禁令

执行实现/修改任务期间，Agent 不得修改 AGENTS.md。
发现本文件缺陷：在完成报告中列出文件、改动点、对当前结果的影响，等用户指示。
生成是验证当前规则的确定性流程，不是调试规则的时机。

## 提交前纪律

逐行读 diff；./check.sh 全绿；未越出 AI 可写分区；
新增 defcustom 的 docstring 必须写清默认值语义与生效时机。

## 约束优先级

冲突时：本文件 > 当前任务提示 > 外部 skill 约定 > 模型默认行为。不自行权衡，按序裁决。

## 维护触发

- 同一规则被违反两次 → 在「工程纪律」补反例
- 公共命令（vjump-back / vjump-forward / vjump-list / vjump-mark / vjump-mode 及 vjump-list 模式命令）签名变更 → 同步本文件与断言
