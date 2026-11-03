#!/usr/bin/env bash
# Collect the diff a review should look at, with the facts around it.
# Usage: collect-diff.sh [base-ref]
#   No argument: uncommitted changes (staged and unstaged) against HEAD,
#     plus any untracked files, which git diff never shows on its own.
#   With a ref: committed changes in the three-dot range base...HEAD,
#     that is, from the merge base of base and HEAD up to HEAD. That is
#     what this branch changed since it diverged, not a point-to-point
#     comparison of the two trees, and never uncommitted work.
# Prints a file summary first, then the full diff. Prints NO_CHANGES
# and exits 0 only when there is genuinely nothing to review: no
# tracked diff and no untracked files.
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: not inside a git repository. Run this from inside the repository to review." >&2
  exit 1
fi

untracked="$(git ls-files --others --exclude-standard)"

if [ $# -ge 1 ]; then
  base="$1"
  if ! git rev-parse --verify --quiet "$base" >/dev/null; then
    echo "ERROR: '$base' is not a ref git can resolve." >&2
    exit 1
  fi
  scope="$base...HEAD"
  label="committed changes in $base...HEAD (merge base to HEAD)"
  stat="$(git diff --stat "$scope")"
  if [ -z "$stat" ]; then
    echo "NO_CHANGES: no diff for $label."
    exit 0
  fi
  echo "## Scope: $label"
  echo
  echo "## Changed files"
  echo "$stat"
  echo
  echo "## Full diff"
  git diff "$scope"
  if [ -n "$untracked" ]; then
    echo
    echo "## Untracked files (in the working tree, NOT part of the range above)"
    echo "$untracked"
  fi
  exit 0
fi

label="uncommitted changes against HEAD"
stat="$(git diff --stat HEAD)"
if [ -z "$stat" ] && [ -z "$untracked" ]; then
  echo "NO_CHANGES: no diff for $label and no untracked files."
  exit 0
fi

echo "## Scope: $label"
if [ -n "$stat" ]; then
  echo
  echo "## Changed files"
  echo "$stat"
  echo
  echo "## Full diff"
  git diff HEAD
fi
if [ -n "$untracked" ]; then
  echo
  echo "## Untracked files (new, not yet tracked; shown in full)"
  while IFS= read -r f; do
    echo
    echo "### $f"
    git diff --no-index -- /dev/null "$f" || true
  done <<< "$untracked"
fi
