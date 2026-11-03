---
name: review-diff
description: Reviews a git diff for correctness, security, error-handling, and test-coverage problems, then reports findings in a fixed format with file and line references. Use when asked to review uncommitted changes, a branch, a pull request diff, or recent commits before merging.
license: MIT
compatibility: Requires git and a POSIX shell. The reviewing agent needs filesystem and shell access.
metadata:
  author: kodedmo
  version: "1.0"
---

# Review a diff

Review the change the user points at. Report problems; do not fix them.
The output of this skill is a review the user can act on, not a rewrite.

## Inputs

- No argument: review the uncommitted changes in the working tree.
- One argument: treat it as a git ref (a branch, a tag, or a commit) and
  review the committed changes in the three-dot range `ref...HEAD`:
  what `HEAD` changed since it diverged from that ref.

## Procedure

1. Collect the diff with the bundled script, `scripts/collect-diff.sh`,
   which sits next to this file in the skill folder. Run it by that
   folder's path, never as a path inside the repository under review:
   the script belongs to the skill, and it reviews whichever
   repository is the current directory when it runs. In Claude Code,
   `${CLAUDE_SKILL_DIR}` expands to this skill's folder:

   ```bash
   bash "${CLAUDE_SKILL_DIR}/scripts/collect-diff.sh"          # uncommitted changes
   bash "${CLAUDE_SKILL_DIR}/scripts/collect-diff.sh" main     # changes since main
   ```

   In a tool without that substitution, use the absolute path of the
   folder this file was loaded from, with the same two forms. Run it
   from inside the repository to review, with no argument for
   uncommitted changes or with the ref the user named. With a ref, the
   range is `base...HEAD` in git's three-dot sense: the changes on
   `HEAD` since it diverged from the base (merge base to `HEAD`), not
   a point-to-point comparison of the two trees, and not uncommitted
   work.

   The script prints `NO_CHANGES` only when there is genuinely
   nothing: no tracked diff and no untracked files. Untracked files
   are listed and shown in full by the script, because `git diff`
   never includes them; review them as part of the change. If it
   prints `NO_CHANGES`, there is nothing to review: say so in one
   line and stop.

2. Read `references/review-checklist.md` in this skill folder. It is the
   standard the review is held to. Work through every category; a
   category with no findings is a result, not a step you skipped.

3. Review the diff hunk by hunk against the checklist. For every claim
   about code outside the diff (a helper that already exists, an API
   with a different signature), open the file and check. Do not report
   a problem you have not verified in the source.

4. Check the tests. If the change alters behaviour, find the test that
   covers it and confirm the test would fail if the change were
   reverted. Name the covering test, or report its absence as a finding.

5. Write the review using the structure in `assets/report-template.md`
   in this skill folder. Every finding gets a file and line reference,
   a severity, what is wrong, why it matters, and the direction of a
   fix. Do not paste the diff back into the report.

## Rules

- Never edit code during a review. If the user then asks for fixes,
  that is a new task.
- Findings are claims about the code. Verify each one against the
  source before reporting it; an invented API or a misread condition
  reported as a blocker costs more than a missed nit.
- Rank by consequence, not by order of appearance: a wrong result or a
  leaked secret outranks a naming nit every time.
- If the diff is large, say which files you reviewed in full and which
  you skimmed. A review that quietly covered half the change is worse
  than one that states its limits.
