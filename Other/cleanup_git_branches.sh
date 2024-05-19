#!/bin/bash

# Fetch all updates from remote and prune deleted branches
git fetch --all --prune

# Loop through all local branches that have ': gone]' in their description
for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
  # Delete the local branch
  git branch -d $branch
done