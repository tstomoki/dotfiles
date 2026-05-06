#!/usr/bin/env bash
# 呼び出し元のペインIDを第1引数で受け取る
CALLER_PANE="$1"

# fzf でファイルを選択（bat でプレビュー）
SELECTED=$(find . -type f | fzf \
  --preview 'bat --style=numbers --color=always {}' \
  --preview-window=right:60%)

# ファイルが選択された場合、呼び出し元ペインに "@ファイルパス " を送信
if [ -n "$SELECTED" ]; then
  tmux send-keys -t "$CALLER_PANE" "@${SELECTED} " ""
fi
