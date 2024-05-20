#!/bin/bash

tmux new-session -d -s monitor
tmux split-window -h
tmux send-keys 'sudo iotop' C-m
tmux select-pane -t 1
tmux send-keys 'htop' C-m
tmux attach-session -t monitor