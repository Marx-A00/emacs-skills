---
name: walkthrough
description: 'When presenting multi-step plans, code reviews, or multi-file explanations that reference 3 or more specific code locations, use claude-walkthrough-start to present them as an interactive step-by-step walkthrough in the user Emacs editor instead of dumping text in the terminal.'
tools: Bash
---

# Interactive code walkthroughs in Emacs

When you need to present multi-step content that references specific code locations — plans, code reviews, feature explanations, refactoring walkthroughs — push an interactive walkthrough to the user's Emacs instead of outputting a wall of text.

The walkthrough highlights code regions with gruvbox-yellow overlays and shows a floating posframe popup with your annotation. The user navigates at their own pace with `n` (next), `p` (prev), and `q` (quit).

## When to use

Use walkthrough mode when ALL of these are true:
- You are referencing **3 or more specific code locations** (file + line range)
- The content is **sequential** — there is a natural order to step through
- The user's Emacs server is reachable via emacsclient

Common scenarios:
- Presenting a plan: "Here are the 5 changes we need to make..."
- Code review: "I found issues in these 4 locations..."
- Explaining a feature: "The call chain goes through these files..."
- Walking through changes you just made: "Here's what I changed and why..."

## When NOT to use

- Single-file, single-location explanations — just use `/open` or `/highlight`
- Non-code discussions or conceptual explanations
- The user explicitly asks for text output
- Quick answers that don't reference specific line ranges
- Fewer than 3 code locations

## How to start a walkthrough

Call `claude-walkthrough-start` via emacsclient with a list of steps. Each step is a plist with `:file`, `:line-start`, `:line-end`, `:title`, and `:body`.

```sh
emacsclient --eval '
(claude-walkthrough-start
 (list
  (list :file "/absolute/path/to/file1.el"
        :line-start 42
        :line-end 58
        :title "Initialize the config"
        :body "This section sets up the base configuration.\nWe need to add the new option here.")
  (list :file "/absolute/path/to/file2.el"
        :line-start 10
        :line-end 25
        :title "Add the handler"
        :body "The handler processes incoming requests.\nWe will extend this to support the new format.")
  (list :file "/absolute/path/to/file3.el"
        :line-start 100
        :line-end 115
        :title "Update the tests"
        :body "These tests cover the handler.\nWe need to add a case for the new format.")))'
```

## Step construction guidelines

- **3-10 steps** is the sweet spot. More than 10 feels tedious, fewer than 3 doesn't justify the walkthrough.
- **Titles**: short and action-oriented. "Add auth middleware", not "This is the section where we need to add the authentication middleware".
- **Body**: explain the **why**, not just the what. The code is right there — the user can see the what. Your annotation should add context.
- **Line ranges**: be precise. Highlight only the relevant lines, not the entire file. A 5-20 line range is ideal.
- **File paths**: always absolute. Use the project root to construct full paths.
- **Each step self-contained**: the user should understand the step without remembering all previous steps.
- **Newlines in body**: use `\n` for line breaks in the body text.

## After starting

After the emacsclient command succeeds, briefly tell the user in the terminal:
- How many steps the walkthrough has
- That they can press `n`/`p`/`q` to navigate
- A one-line summary of what the walkthrough covers

Example terminal output after starting:
> Walkthrough started (5 steps) — walking through the auth refactoring plan. Press `n` to advance, `q` to quit.

Do NOT also dump the full plan as text. The walkthrough IS the presentation. Keep terminal output minimal.

## Sandbox server

If the user's Emacs is running via the sandbox, use `--socket-name=sandbox`:

```sh
emacsclient --socket-name=sandbox --eval '(claude-walkthrough-start ...)'
```

## Rules

- Always use absolute file paths.
- Always verify the walkthrough started successfully (check emacsclient exit code).
- If emacsclient fails (server not running), fall back to text output in the terminal.
- Run the `emacsclient --eval` command via the Bash tool.
- Do not repeat the walkthrough content as text in the terminal.
- Keep step count between 3 and 10.
