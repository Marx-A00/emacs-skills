(require 'cl-lib)

(cl-defun agent-skill-open-ow (&key files)
  "Open FILES in other windows, never replacing the current one.

FILES is a list of file specs.  Each spec is either a string
\(file path) or a plist (:file PATH :line LINE).

When called from an agent-shell buffer (or any context where the
current window should be preserved), files open in an existing
side window or a new split to the right."
  (dolist (spec files)
    (let* ((file (if (stringp spec) spec (plist-get spec :file)))
           (line (unless (stringp spec) (plist-get spec :line)))
           (buf (find-file-noselect (expand-file-name file))))
      (display-buffer buf
                      '((display-buffer-reuse-window
                         display-buffer-use-some-window
                         display-buffer-in-direction)
                        (inhibit-same-window . t)
                        (direction . right)))
      (when-let ((win (get-buffer-window buf)))
        (select-window win)
        (when line
          (goto-char (point-min))
          (forward-line (1- line))
          (recenter))))))

(provide 'agent-skill-open-ow)
