---
name: open-ow
description: 'This skill should be used when the user invokes "/open-ow" to open files from the latest interaction in Emacs buffers via emacsclient, in a window beside the current one (other window).'
tools: Bash
disable-model-invocation: true
---

# Open files in Emacs (other window)

Open files from the most recent interaction in Emacs buffers using `emacsclient --eval`, displaying them in another window — never replacing the current one. This is useful when the current window is an agent-shell buffer that should stay visible.

## How to open

First, locate `agent-skill-open-ow.el` which lives alongside this skill file at `skills/open-ow/agent-skill-open-ow.el` in the emacs-skills plugin directory.

Each file spec in `:files` is either a string (file path) or a plist with `:file` and optional `:line`.

```sh
emacsclient --eval '
(progn
  (load "/path/to/skills/open-ow/agent-skill-open-ow.el" nil t)
  (agent-skill-open-ow
    :files (quote ((:file "/path/to/file1.txt"
                    :line 42)
                   "/path/to/file2.txt"
                   "/path/to/file3.txt"))))'
```

## Rules

- Use absolute paths for files.
- Use `:line` when a specific line is relevant (e.g., an error location or a newly added function).
- Locate `agent-skill-open-ow.el` relative to this skill file's directory.
- If no relevant files exist in the recent interaction, inform the user.
- Run the `emacsclient --eval` command via the Bash tool.
