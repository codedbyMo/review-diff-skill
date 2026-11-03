# review-diff — an Agent Skill for reviewing git diffs

Companion code for the blog post "Build Your First Agent Skill: Turn
Your Coding Agent Into a Platform" (post #22, kodedmo.dev). This
repository is the skill folder itself, in the open Agent Skills
format: copy it into a skills directory and any compatible agent can
use it.

## Contents

- `SKILL.md` — metadata and the review procedure (the skill itself)
- `scripts/collect-diff.sh` — deterministic diff collector the
  procedure runs: uncommitted changes (staged, unstaged, and
  untracked files) or a committed `base...HEAD` range
- `references/review-checklist.md` — the standard reviews are held to
- `assets/report-template.md` — the fixed report format

## Install

- Claude Code, personal: copy this folder to `~/.claude/skills/review-diff/`
- Claude Code, project: copy it to `.claude/skills/review-diff/` in a repo
- Codex: copy it to `~/.agents/skills/review-diff/` or a repo's `.agents/skills/review-diff/`

The folder name must stay `review-diff`; it has to match the `name`
in `SKILL.md`.

## Verified

- Format validated with the official `skills-ref` validator
  (`agentskills validate`): "Valid skill: review-diff".
- The collector script was exercised on November 3, 2026 across a
  nine-case matrix (clean tree, staged only, unstaged only, untracked
  only, mixed, invalid ref, committed range, range with untracked
  files present, outside any repo). All cases behaved as documented,
  including the untracked-only case, which lists and shows the new
  files instead of reporting no changes.
