#!/usr/bin/env bash

paths=$(yazi --chooser-file=/dev/stdout)

if [[ -n "$paths" ]]; then
	tmux last-window
	tmux send-keys Escape
	tmux send-keys ":$2 $paths"
	tmux send-keys Enter
else
	tmux kill-window -t fx
fi

