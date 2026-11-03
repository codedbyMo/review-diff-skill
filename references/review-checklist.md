# Review checklist

The standard a review with this skill is held to. Work through every
category for every diff. Verify each finding in the source before
reporting it.

## 1. Correctness

- Boundary conditions: `>` where the intent is `>=`, loops that stop
  one element early or late, empty-input handling.
- Conditions inverted or quietly widened/narrowed by the change.
- Defaults that changed in a shared helper: every caller inherits them.
- Arithmetic that can overflow, divide by zero, or lose precision
  (money, timestamps, counters).

## 2. Called code exists

- Every function, method, and import the change calls exists in the
  codebase or its declared dependencies, with that name and a
  compatible signature. Open the definition; do not trust the call
  site's spelling.
- No second copy of a helper the codebase already has. Duplication is
  locally safe and globally expensive.

## 3. Error handling

- Caught errors that are logged and swallowed, or not caught at all on
  a path that can fail (network, parsing, file access).
- A fallback or default that hides a failure and lets the program
  continue with wrong data.
- Async work whose rejection nobody awaits or handles.

## 4. Security

- Secrets, tokens, or credentials written into source, even "temporary"
  ones.
- User input reaching a query, a shell command, a path, or HTML
  without the escaping/sanitising the surrounding code uses.
- New endpoints or handlers without the authentication/authorisation
  checks their neighbours have.
- Dependencies added without a reason.

## 5. Tests

- A behaviour change has a test that fails when the change is
  reverted. Name it.
- Tests assert behaviour, not the implementation's current output.
- A bug fix starts from a reproduction: a test that failed for the
  reported reason before the fix.

## 6. Scope

- One concern per change. Refactors mixed into behaviour changes get
  flagged, because neither can be reviewed as what it is.
- Files changed that the stated task does not explain.
