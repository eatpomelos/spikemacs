#!/usr/bin/env bash
# vjump 确定性门禁（AGENTS.md「测试与验证」层的可执行路径）
# 职责边界：编译、warning、行为断言。语义质量（设计合理性）归人工审查层。
set -u
cd "$(dirname "$0")"
EMACS=${EMACS:-emacs}

echo "== 1/2 byte-compile（零 warning 才过） =="
out=$("$EMACS" --batch -Q -L . -f batch-byte-compile vjump.el vjump-test.el 2>&1)
rc=$?
printf '%s\n' "$out"
if [ "$rc" -ne 0 ]; then
  echo "GATE FAIL: byte-compile 出错 (rc=$rc)"
  exit 1
fi
if printf '%s' "$out" | grep -qi 'warning'; then
  echo "GATE FAIL: byte-compile 存在 warning"
  exit 1
fi
rm -f vjump.elc

echo "== 2/2 行为断言（vjump-self-test，内置） =="
"$EMACS" --batch -Q -L . -l vjump-test.el --eval '(vjump-self-test)' || exit 1

echo "GATE PASS"
