# Persistent Bash History with Timestamps (Ubuntu)

This document explains **exactly what to change in `~/.bashrc`** to make your Bash command history:

* Persistent across reboots and logouts
* Unlimited (never truncated)
* Shared across all terminals
* Timestamped for every command

No shell commands are required beyond editing `~/.bashrc`.

---

## Scope & Assumptions

* Shell: **bash**
* OS: **Ubuntu / Debian-based**
* File edited: `~/.bashrc`

---

## Step 1 — Open `~/.bashrc`

Edit your existing `~/.bashrc` file using any editor.

---

## Step 2 — Modify existing history settings

### Find these existing lines (near the top):

```bash
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=1000
```

### Replace them with:

```bash
HISTCONTROL=ignoredups:erasedups
HISTSIZE=
HISTFILESIZE=
```

**Why:**

* Removes the 1000-command limit
* Ensures duplicate commands are cleaned globally

---

## Step 3 — Keep this line as-is

If you already have this line, **do not remove it**:

```bash
shopt -s histappend
```

This ensures history is appended instead of overwritten.

---

## Step 4 — Add persistent timestamp configuration (bottom of file)

Scroll to the **very end** of `~/.bashrc` and add:

```bash
# =========================
# Persistent history + timestamps
# =========================

export HISTFILE="$HOME/.bash_history"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "

PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
```

---

## Final Result

After saving the file:

* History is written after **every command**
* Commands are shared across all open terminals
* History is never truncated
* Each command includes a timestamp
* Works across reboot, logout, SSH, tmux, VS Code terminal

---

## Notes

* Root (`sudo -i`) uses a separate history file: `/root/.bash_history`
* No other config files are required (`.bash_profile`, `.profile`, etc.)
* This setup is safe and standard for long-term use

---

## Summary

You only touched:

* `HISTCONTROL`
* `HISTSIZE`
* `HISTFILESIZE`
* Added a timestamp + persistence block at the end

Nothing else in your `.bashrc` was changed.

- after all
```
source ~/.bashrc
```
