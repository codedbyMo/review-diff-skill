# Review: [scope, e.g. "uncommitted changes" or "main...HEAD"]

## Summary

Two or three lines: what the change does, and the overall assessment.

## Findings

### Blockers

- `path/to/file.js:42`: What is wrong, why it matters, and the
  direction of a fix. One finding per bullet.

### Should fix

- `path/to/file.js:17`: Same format.

### Nits

- `path/to/file.js:88`: Same format. Omit this section if empty;
  omit Blockers or Should fix the same way rather than padding them.

## Test coverage

Which tests cover the changed behaviour, whether they fail with the
change reverted, and any behaviour change with no covering test.

## Verdict

One of: approve / approve with fixes / request changes, with the
single most important reason.
